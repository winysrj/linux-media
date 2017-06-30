Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:35600 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751666AbdF3O4z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 10:56:55 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Eric Anholt <eric@anholt.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC PATCH] cec-*: monitor pin support
Message-ID: <120c14ca-e12a-761f-a628-07aa8ec2d862@xs4all.nl>
Date: Fri, 30 Jun 2017 16:56:51 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support the new pin monitoring events API in the CEC utilities.

It needs a bit more cleanup before it is ready to be merged, and I am sure that
more work can be done to refine the analysis code. But this is a good first start.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/linux/cec.h                     |   8 +-
 utils/cec-compliance/cec-compliance.cpp |   2 +
 utils/cec-ctl/cec-ctl.cpp               | 311 +++++++++++++++++++++++++++++++-
 utils/cec-follower/cec-follower.cpp     |   2 +
 utils/cec-follower/cec-processing.cpp   |   2 +
 5 files changed, 316 insertions(+), 9 deletions(-)

diff --git a/include/linux/cec.h b/include/linux/cec.h
index 44579a24..d87a67b0 100644
--- a/include/linux/cec.h
+++ b/include/linux/cec.h
@@ -318,6 +318,7 @@ static inline int cec_is_unconfigured(__u16 log_addr_mask)
 #define CEC_MODE_FOLLOWER		(0x1 << 4)
 #define CEC_MODE_EXCL_FOLLOWER		(0x2 << 4)
 #define CEC_MODE_EXCL_FOLLOWER_PASSTHRU	(0x3 << 4)
+#define CEC_MODE_MONITOR_PIN		(0xd << 4)
 #define CEC_MODE_MONITOR		(0xe << 4)
 #define CEC_MODE_MONITOR_ALL		(0xf << 4)
 #define CEC_MODE_FOLLOWER_MSK		0xf0
@@ -338,6 +339,8 @@ static inline int cec_is_unconfigured(__u16 log_addr_mask)
 #define CEC_CAP_MONITOR_ALL	(1 << 5)
 /* Hardware can use CEC only if the HDMI HPD pin is high. */
 #define CEC_CAP_NEEDS_HPD	(1 << 6)
+/* Hardware can monitor CEC pin transitions */
+#define CEC_CAP_MONITOR_PIN	(1 << 7)

 /**
  * struct cec_caps - CEC capabilities structure.
@@ -405,8 +408,11 @@ struct cec_log_addrs {
  * didn't empty the message queue in time
  */
 #define CEC_EVENT_LOST_MSGS		2
+#define CEC_EVENT_PIN_LOW		3
+#define CEC_EVENT_PIN_HIGH		4

 #define CEC_EVENT_FL_INITIAL_STATE	(1 << 0)
+#define CEC_EVENT_FL_DROPPED_EVENTS	(1 << 1)

 /**
  * struct cec_event_state_change - used when the CEC adapter changes state.
@@ -419,7 +425,7 @@ struct cec_event_state_change {
 };

 /**
- * struct cec_event_lost_msgs - tells you how many messages were lost due.
+ * struct cec_event_lost_msgs - tells you how many messages were lost.
  * @lost_msgs: how many messages were lost.
  */
 struct cec_event_lost_msgs {
diff --git a/utils/cec-compliance/cec-compliance.cpp b/utils/cec-compliance/cec-compliance.cpp
index 0dd2a54f..1badf8be 100644
--- a/utils/cec-compliance/cec-compliance.cpp
+++ b/utils/cec-compliance/cec-compliance.cpp
@@ -261,6 +261,8 @@ static std::string caps2s(unsigned caps)
 		s += "\t\tMonitor All\n";
 	if (caps & CEC_CAP_NEEDS_HPD)
 		s += "\t\tNeeds HPD\n";
+	if (caps & CEC_CAP_MONITOR_PIN)
+		s += "\t\tMonitor Pin\n";
 	return s;
 }

diff --git a/utils/cec-ctl/cec-ctl.cpp b/utils/cec-ctl/cec-ctl.cpp
index 80d4014a..7b23ab7e 100644
--- a/utils/cec-ctl/cec-ctl.cpp
+++ b/utils/cec-ctl/cec-ctl.cpp
@@ -668,6 +668,7 @@ enum Option {
 	OptReplyToFollowers,
 	OptTimeout,
 	OptMonitorTime,
+	OptMonitorPin,
 	OptListUICommands,
 	OptRcTVProfile1,
 	OptRcTVProfile2,
@@ -730,6 +731,7 @@ static struct option long_options[] = {
 	{ "clear", no_argument, 0, OptClear },
 	{ "monitor", no_argument, 0, OptMonitor },
 	{ "monitor-all", no_argument, 0, OptMonitorAll },
+	{ "monitor-pin", no_argument, 0, OptMonitorPin },
 	{ "monitor-time", required_argument, 0, OptMonitorTime },
 	{ "no-reply", no_argument, 0, OptNoReply },
 	{ "to", required_argument, 0, OptTo },
@@ -786,6 +788,7 @@ static void usage(void)
 	       "  -C, --clear              Clear all logical addresses\n"
 	       "  -m, --monitor            Monitor CEC traffic\n"
 	       "  -M, --monitor-all        Monitor all CEC traffic\n"
+	       "  --monitor-pin            Monitor low-level CEC pin\n"
 	       "  --monitor-time=<secs>    Monitor for <secs> seconds (default is forever)\n"
 	       "  -n, --no-reply           Don't wait for a reply\n"
 	       "  -t, --to=<la>            Send message to the given logical address\n"
@@ -857,6 +860,8 @@ static std::string caps2s(unsigned caps)
 		s += "\t\tMonitor All\n";
 	if (caps & CEC_CAP_NEEDS_HPD)
 		s += "\t\tNeeds HPD\n";
+	if (caps & CEC_CAP_MONITOR_PIN)
+		s += "\t\tMonitor Pin\n";
 	return s;
 }

@@ -1224,11 +1229,231 @@ static void log_unknown_msg(const struct cec_msg *msg)
 	}
 }

+enum cec_state {
+	CEC_ST_IDLE,
+	CEC_ST_RECEIVE_START_BIT,
+	CEC_ST_RECEIVING_DATA,
+};
+
+/* All timings are in microseconds */
+#define CEC_TIM_MARGIN			100
+
+#define CEC_TIM_START_BIT_LOW		3700
+#define CEC_TIM_START_BIT_LOW_MIN	3500
+#define CEC_TIM_START_BIT_LOW_MAX	3900
+#define CEC_TIM_START_BIT_TOTAL		4500
+#define CEC_TIM_START_BIT_TOTAL_MIN	4300
+#define CEC_TIM_START_BIT_TOTAL_MAX	4700
+
+#define CEC_TIM_DATA_BIT_0_LOW		1500
+#define CEC_TIM_DATA_BIT_0_LOW_MIN	1300
+#define CEC_TIM_DATA_BIT_0_LOW_MAX	1700
+#define CEC_TIM_DATA_BIT_1_LOW		600
+#define CEC_TIM_DATA_BIT_1_LOW_MIN	400
+#define CEC_TIM_DATA_BIT_1_LOW_MAX	800
+#define CEC_TIM_DATA_BIT_TOTAL		2400
+#define CEC_TIM_DATA_BIT_TOTAL_MIN	2050
+#define CEC_TIM_DATA_BIT_TOTAL_MAX	2750
+#define CEC_TIM_DATA_BIT_SAMPLE		1050
+#define CEC_TIM_DATA_BIT_SAMPLE_MIN	850
+#define CEC_TIM_DATA_BIT_SAMPLE_MAX	1250
+
+#define CEC_TIM_IDLE_SAMPLE		1000
+#define CEC_TIM_IDLE_SAMPLE_MIN		500
+#define CEC_TIM_IDLE_SAMPLE_MAX		1500
+#define CEC_TIM_START_BIT_SAMPLE	500
+#define CEC_TIM_START_BIT_SAMPLE_MIN	300
+#define CEC_TIM_START_BIT_SAMPLE_MAX	700
+
+#define CEC_TIM_LOW_DRIVE_ERROR         (1.5 * CEC_TIM_DATA_BIT_TOTAL)
+#define CEC_TIM_LOW_DRIVE_ERROR_MIN     (1.4 * CEC_TIM_DATA_BIT_TOTAL)
+#define CEC_TIM_LOW_DRIVE_ERROR_MAX     (1.6 * CEC_TIM_DATA_BIT_TOTAL)
+
+static __u64 eob_ts;
+static __u64 eob_ts_max;
+
+static void cec_pin_debug(__u64 ev_ts, __u64 usecs, bool was_high, bool is_high)
+{
+	static enum cec_state state;
+	static __u64 ts;
+	static __u64 low_usecs;
+	static unsigned int rx_bit;
+	static __u8 byte;
+	static bool eom;
+	static bool first_byte;
+	static bool bcast;
+	__u64 usecs_min = usecs > CEC_TIM_MARGIN ? usecs - CEC_TIM_MARGIN : 0;
+
+	ts += usecs;
+
+	switch (state) {
+	case CEC_ST_RECEIVE_START_BIT:
+		if (was_high) {
+			if (low_usecs + usecs_min > CEC_TIM_START_BIT_TOTAL_MAX) {
+				state = CEC_ST_IDLE;
+				printf("%10.2f: total start bit time too long (%.2f > %.2f ms)\n",
+					ts / 1000.0, (low_usecs + usecs_min) / 1000.0,
+					CEC_TIM_START_BIT_TOTAL_MAX / 1000.0);
+				break;
+			}
+			if (low_usecs + usecs < CEC_TIM_START_BIT_TOTAL_MIN - CEC_TIM_MARGIN) {
+				state = CEC_ST_IDLE;
+				printf("%10.2f: total start bit time too short (%.2f < %.2f ms)\n",
+					ts / 1000.0, (low_usecs + usecs) / 1000.0,
+					CEC_TIM_START_BIT_TOTAL_MIN / 1000.0);
+				break;
+			}
+			state = CEC_ST_RECEIVING_DATA;
+			rx_bit = 0;
+			byte = 0;
+			eom = false;
+			first_byte = true;
+			bcast = false;
+		} else {
+			if (usecs_min > CEC_TIM_START_BIT_LOW_MAX) {
+				state = CEC_ST_IDLE;
+				printf("%10.2f: start bit low too long (%.2f > %.2f ms)\n",
+					ts / 1000.0, usecs_min / 1000.0,
+					CEC_TIM_START_BIT_LOW_MAX / 1000.0);
+				break;
+			}
+			if (usecs < CEC_TIM_START_BIT_LOW_MIN - CEC_TIM_MARGIN) {
+				state = CEC_ST_IDLE;
+				printf("%10.2f: start bit low too short (%.2f < %.2f ms)\n",
+					ts / 1000.0, usecs / 1000.0,
+					CEC_TIM_START_BIT_LOW_MIN / 1000.0);
+				break;
+			}
+			low_usecs = usecs;
+			eob_ts = ev_ts + 1000 * (CEC_TIM_START_BIT_TOTAL - low_usecs);
+			eob_ts_max = ev_ts + 1000 * (CEC_TIM_START_BIT_TOTAL_MAX - low_usecs);
+		}
+		break;
+	case CEC_ST_RECEIVING_DATA:
+		if (was_high) {
+			bool bit;
+			bool ack = false;
+
+			if (rx_bit < 9 && low_usecs + usecs_min > CEC_TIM_DATA_BIT_TOTAL_MAX) {
+				printf("%10.2f: data bit %d total time too long (%.2f ms)\n",
+					ts / 1000.0, rx_bit, (low_usecs + usecs_min) / 1000.0);
+			}
+			if (low_usecs + usecs < CEC_TIM_DATA_BIT_TOTAL_MIN - CEC_TIM_MARGIN) {
+				printf("%10.2f: data bit %d total time too short (%.2f ms)\n\n",
+					ts / 1000.0, rx_bit, (low_usecs + usecs) / 1000.0);
+			}
+			bit = low_usecs < CEC_TIM_DATA_BIT_1_LOW_MAX + CEC_TIM_MARGIN;
+			if (rx_bit <= 7) {
+				byte |= bit << (7 - rx_bit);
+			} else if (rx_bit == 8) {
+				eom = bit;
+			} else {
+				if (first_byte) {
+					first_byte = false;
+					bcast = (byte & 0xf) == 0xf;
+				}
+				printf("%10.2f: rx 0x%02x%s%s%s (%s)\n",
+				       (ts - usecs) / 1000.0, byte,
+				       eom ? " EOM" : "", (bcast ^ bit) ? " NACK" : " ACK",
+				       bcast ? " (broadcast)" : "",
+				       ts2s(ev_ts - usecs * 1000).c_str());
+				if (show_info)
+					printf("\n");
+				ack = !(bcast ^ bit);
+			}
+			rx_bit++;
+			if (rx_bit == 10) {
+				if ((!eom && ack) && low_usecs + usecs_min > CEC_TIM_DATA_BIT_TOTAL_MAX)
+					printf("%10.2f: data bit %d total time too long (%.2f ms)\n",
+						ts / 1000.0, rx_bit - 1, (low_usecs + usecs_min) / 1000.0);
+				if (eom || is_high)
+					state = is_high ? CEC_ST_IDLE : CEC_ST_RECEIVE_START_BIT;
+				if (state == CEC_ST_IDLE)
+					printf("\n");
+				rx_bit = 0;
+				byte = 0;
+				eom = false;
+			}
+			break;
+		} else {
+			low_usecs = usecs;
+			if (usecs >= CEC_TIM_LOW_DRIVE_ERROR_MIN - CEC_TIM_MARGIN &&
+			    usecs <= CEC_TIM_LOW_DRIVE_ERROR_MAX + CEC_TIM_MARGIN) {
+				state = CEC_ST_IDLE;
+				printf("%10.2f: low drive (%.2f ms) detected\n\n",
+				       ts / 1000.0, usecs / 1000.0);
+				break;
+			}
+			if (usecs_min >= CEC_TIM_LOW_DRIVE_ERROR_MAX) {
+				state = CEC_ST_IDLE;
+				printf("%10.2f: low drive too long (%.2f > %.2f ms)\n\n",
+				       ts / 1000.0, usecs_min / 1000.0,
+				       CEC_TIM_LOW_DRIVE_ERROR_MAX / 1000.0);
+				break;
+			}
+
+			if (rx_bit == 0 && !first_byte) {
+				if (!rx_bit && usecs_min > CEC_TIM_START_BIT_LOW_MAX) {
+					state = CEC_ST_IDLE;
+					printf("%10.2f: start bit low too long (%.2f > %.2f ms)\n\n",
+						ts / 1000.0, usecs_min / 1000.0,
+						CEC_TIM_START_BIT_LOW_MAX / 1000.0);
+					break;
+				}
+				if (usecs >= CEC_TIM_START_BIT_LOW_MIN - CEC_TIM_MARGIN) {
+					state = CEC_ST_RECEIVE_START_BIT;
+					break;
+				}
+			}
+			if (usecs_min > CEC_TIM_DATA_BIT_0_LOW_MAX) {
+				printf("%10.2f: data bit %d low too long (%.2f ms)\n",
+					ts / 1000.0, rx_bit, usecs_min / 1000.0);
+				if (usecs_min > CEC_TIM_DATA_BIT_TOTAL_MAX) {
+					state = CEC_ST_IDLE;
+					printf("\n");
+				}
+				break;
+			}
+			if (usecs_min > CEC_TIM_DATA_BIT_1_LOW_MAX &&
+			    usecs < CEC_TIM_DATA_BIT_0_LOW_MIN - CEC_TIM_MARGIN) {
+				state = CEC_ST_IDLE;
+				printf("%10.2f: data bit %d invalid 0->1 transition (%.2f ms)\n\n",
+					ts / 1000.0, rx_bit, usecs / 1000.0);
+				break;
+			}
+			if (usecs < CEC_TIM_DATA_BIT_1_LOW_MIN - CEC_TIM_MARGIN) {
+				state = CEC_ST_IDLE;
+				printf("%10.2f: data bit %d low too short (%.2f ms)\n\n",
+					ts / 1000.0, rx_bit, usecs / 1000.0);
+				break;
+			}
+
+			eob_ts = ev_ts + 1000 * (CEC_TIM_DATA_BIT_TOTAL - low_usecs);
+			eob_ts_max = ev_ts + 1000 * (CEC_TIM_DATA_BIT_TOTAL_MAX - low_usecs);
+		}
+		break;
+	case CEC_ST_IDLE:
+		if (!is_high)
+			state = CEC_ST_RECEIVE_START_BIT;
+		break;
+	}
+	if (was_high && is_high)
+		state = CEC_ST_IDLE;
+}
+
 static void log_event(struct cec_event &ev)
 {
+	static __u64 last_ts;
+	static __u64 last_change_ts;
+	static __u64 last_1_to_0_ts;
+	static bool was_high = true;
+	bool is_high = ev.event == CEC_EVENT_PIN_HIGH;
 	__u16 pa;

-	printf("\n");
+	if (ev.event != CEC_EVENT_PIN_LOW && ev.event != CEC_EVENT_PIN_HIGH)
+		printf("\n");
+	if (ev.flags & CEC_EVENT_FL_DROPPED_EVENTS)
+		printf("(Note: events were lost)\n");
 	if (ev.flags & CEC_EVENT_FL_INITIAL_STATE)
 		printf("Initial ");
 	switch (ev.event) {
@@ -1242,6 +1467,52 @@ static void log_event(struct cec_event &ev)
 	case CEC_EVENT_LOST_MSGS:
 		printf("Event: Lost Messages\n");
 		break;
+	case CEC_EVENT_PIN_LOW:
+	case CEC_EVENT_PIN_HIGH:
+		if (ev.flags & CEC_EVENT_FL_INITIAL_STATE)
+			printf("Event: CEC Pin %s\n", is_high ? "High" : "Low");
+
+		eob_ts = eob_ts_max = 0;
+
+		if (last_change_ts == 0) {
+			last_ts = last_change_ts = last_1_to_0_ts = ev.ts - CEC_TIM_DATA_BIT_TOTAL * 16000;
+			if (is_high)
+				break;
+		}
+		if (show_info) {
+			if (last_change_ts)
+				printf("%10.2f ms ", (ev.ts - last_change_ts) / 1000000.0);
+			else
+				printf("%10.2f ms ", 0.0);
+			if (last_change_ts && is_high && was_high)
+				printf("1 -> 1 (%.2f ms, %s)\n",
+				       (ev.ts - last_1_to_0_ts) / 1000000.0,
+				       ts2s(ev.ts).c_str());
+			else if (was_high)
+				printf("1 -> 0 (%.2f ms, %s)\n",
+				       (ev.ts - last_1_to_0_ts) / 1000000.0,
+				       ts2s(ev.ts).c_str());
+			else if (last_change_ts)
+				printf("0 -> 1 (%d, %s)\n",
+				       (ev.ts - last_change_ts) / 1000 < CEC_TIM_DATA_BIT_1_LOW_MAX + CEC_TIM_MARGIN,
+				       ts2s(ev.ts).c_str());
+			else
+				printf("0 -> 1\n");
+			last_change_ts = ev.ts;
+			if (ev.event == CEC_EVENT_PIN_LOW)
+				last_1_to_0_ts = ev.ts;
+		}
+		cec_pin_debug(ev.ts, (ev.ts - last_ts) / 1000, was_high, is_high);
+		if (!is_high) {
+			float usecs = (ev.ts - last_ts) / 1000;
+			unsigned periods = usecs / CEC_TIM_DATA_BIT_TOTAL;
+
+			if (periods > 1 && periods < 10)
+				printf("free signal time = %.1f bit periods\n", usecs / CEC_TIM_DATA_BIT_TOTAL);
+		}
+		last_ts = ev.ts;
+		was_high = is_high;
+		return;
 	default:
 		printf("Event: Unknown (0x%x)\n", ev.event);
 		break;
@@ -2087,7 +2358,7 @@ int main(int argc, char **argv)
 		}
 	}
 	if (node.num_log_addrs == 0) {
-		if (options[OptMonitor] || options[OptMonitorAll])
+		if (options[OptMonitor] || options[OptMonitorAll] || options[OptMonitorPin])
 			goto skip_la;
 		return 0;
 	}
@@ -2137,9 +2408,10 @@ int main(int argc, char **argv)
 	fflush(stdout);

 skip_la:
-	if (options[OptMonitor] || options[OptMonitorAll]) {
+	if (options[OptMonitor] || options[OptMonitorAll] || options[OptMonitorPin]) {
 		__u32 monitor = options[OptMonitorAll] ?
-			CEC_MODE_MONITOR_ALL : CEC_MODE_MONITOR;
+			CEC_MODE_MONITOR_ALL : (options[OptMonitorPin] ? CEC_MODE_MONITOR_PIN :
+						CEC_MODE_MONITOR);
 		fd_set rd_fds;
 		fd_set ex_fds;
 		int fd = node.fd;
@@ -2151,6 +2423,11 @@ skip_la:
 			printf("Monitor All mode is not supported, falling back to regular monitoring\n");
 			monitor = CEC_MODE_MONITOR;
 		}
+		if (!(node.caps & CEC_CAP_MONITOR_PIN) &&
+		    monitor == CEC_MODE_MONITOR_PIN) {
+			printf("Monitor Pin mode is not supported, falling back to regular monitoring\n");
+			monitor = CEC_MODE_MONITOR;
+		}
 		if (doioctl(&node, CEC_S_MODE, &monitor)) {
 			printf("Selecting monitor mode failed, you may have to run this as root.\n");
 			goto skip_mon;
@@ -2158,8 +2435,9 @@ skip_la:

 		fcntl(fd, F_SETFL, fcntl(fd, F_GETFL) | O_NONBLOCK);
 		t = time(NULL) + monitor_time;
-		while (1) {
-			struct timeval tv = { t - time(NULL), 0 };
+		while (!monitor_time || time(NULL) < t) {
+			struct timeval tv = { 1, 0 };
+			bool pin_event = false;
 			int res;

 			fflush(stdout);
@@ -2167,8 +2445,8 @@ skip_la:
 			FD_ZERO(&ex_fds);
 			FD_SET(fd, &rd_fds);
 			FD_SET(fd, &ex_fds);
-			res = select(fd + 1, &rd_fds, NULL, &ex_fds, monitor_time ? &tv : NULL);
-			if (res <= 0)
+			res = select(fd + 1, &rd_fds, NULL, &ex_fds, &tv);
+			if (res < 0)
 				break;
 			if (FD_ISSET(fd, &rd_fds)) {
 				struct cec_msg msg = { };
@@ -2203,8 +2481,25 @@ skip_la:

 				if (doioctl(&node, CEC_DQEVENT, &ev))
 					continue;
+				if (ev.event == CEC_EVENT_PIN_LOW ||
+				    ev.event == CEC_EVENT_PIN_HIGH)
+					pin_event = true;
 				log_event(ev);
 			}
+			if (!pin_event && eob_ts) {
+				struct timespec ts;
+				__u64 ts64;
+
+				clock_gettime(CLOCK_MONOTONIC, &ts);
+				ts64 = ts.tv_sec * 1000000000ULL + ts.tv_nsec;
+				if (ts64 >= eob_ts_max) {
+					struct cec_event ev = {
+						.ts = eob_ts,
+						.event = CEC_EVENT_PIN_HIGH,
+					};
+					log_event(ev);
+				}
+			}
 		}
 	}
 	fflush(stdout);
diff --git a/utils/cec-follower/cec-follower.cpp b/utils/cec-follower/cec-follower.cpp
index 70ff7e74..fafad84a 100644
--- a/utils/cec-follower/cec-follower.cpp
+++ b/utils/cec-follower/cec-follower.cpp
@@ -123,6 +123,8 @@ static std::string caps2s(unsigned caps)
 		s += "\t\tMonitor All\n";
 	if (caps & CEC_CAP_NEEDS_HPD)
 		s += "\t\tNeeds HPD\n";
+	if (caps & CEC_CAP_MONITOR_PIN)
+		s += "\t\tMonitor Pin\n";
 	return s;
 }

diff --git a/utils/cec-follower/cec-processing.cpp b/utils/cec-follower/cec-processing.cpp
index 1e4527bb..88ab8286 100644
--- a/utils/cec-follower/cec-processing.cpp
+++ b/utils/cec-follower/cec-processing.cpp
@@ -176,6 +176,8 @@ static void log_event(struct cec_event &ev)
 {
 	__u16 pa;

+	if (ev.flags & CEC_EVENT_FL_DROPPED_EVENTS)
+		printf("(Note: events were lost)\n");
 	if (ev.flags & CEC_EVENT_FL_INITIAL_STATE)
 		printf("Initial ");
 	switch (ev.event) {
-- 
2.11.0
