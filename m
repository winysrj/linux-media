Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:57832 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZBEQKO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Feb 2009 11:10:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] Make exported headers use strict posix types
Date: Thu, 5 Feb 2009 17:07:53 +0100
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>, mingo@elte.hu,
	x86@kernel.org, sam@ravnborg.org, jirislaby@gmail.com,
	gregkh@suse.de, davem@davemloft.net, xyzzy@speakeasy.org,
	mchehab@infradead.org, jens.axboe@oracle.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Avi Kivity <avi@redhat.com>
References: <20090204064307.GA18415@gondor.apana.org.au> <200902051530.25897.arnd@arndb.de> <498B0315.5080804@zytor.com>
In-Reply-To: <498B0315.5080804@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902051707.55457.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A number of standard posix types are used in exported headers, which
is not allowed if __STRICT_KERNEL_NAMES is defined. Change them all
to use the safe __kernel variant so that we can make __STRICT_KERNEL_NAMES
the default.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---
On Thursday 05 February 2009, H. Peter Anvin wrote:

> I have been advocating for hacking headers_install for a while.  That
> takes care of the 106.  The 15 *need* to be audited immediately, because
> that is even likely to be actual manifest bugs.

This is what I found, please review.

diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index b847741..4d3e483 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -117,9 +117,9 @@
 struct flock {
 	short	l_type;
 	short	l_whence;
-	off_t	l_start;
-	off_t	l_len;
-	pid_t	l_pid;
+	__kernel_off_t	l_start;
+	__kernel_off_t	l_len;
+	__kernel_pid_t	l_pid;
 	__ARCH_FLOCK_PAD
 };
 #endif
@@ -140,9 +140,9 @@ struct flock {
 struct flock64 {
 	short  l_type;
 	short  l_whence;
-	loff_t l_start;
-	loff_t l_len;
-	pid_t  l_pid;
+	__kernel_loff_t l_start;
+	__kernel_loff_t l_len;
+	__kernel_pid_t  l_pid;
 	__ARCH_FLOCK64_PAD
 };
 #endif
diff --git a/include/asm-generic/siginfo.h b/include/asm-generic/siginfo.h
index 9695701..35f75a3 100644
--- a/include/asm-generic/siginfo.h
+++ b/include/asm-generic/siginfo.h
@@ -23,7 +23,7 @@ typedef union sigval {
 #endif
 
 #ifndef __ARCH_SI_UID_T
-#define __ARCH_SI_UID_T	uid_t
+#define __ARCH_SI_UID_T	__kernel_uid_t
 #endif
 
 /*
@@ -47,13 +47,13 @@ typedef struct siginfo {
 
 		/* kill() */
 		struct {
-			pid_t _pid;		/* sender's pid */
+			__kernel_pid_t _pid;	/* sender's pid */
 			__ARCH_SI_UID_T _uid;	/* sender's uid */
 		} _kill;
 
 		/* POSIX.1b timers */
 		struct {
-			timer_t _tid;		/* timer id */
+			__kernel_timer_t _tid;	/* timer id */
 			int _overrun;		/* overrun count */
 			char _pad[sizeof( __ARCH_SI_UID_T) - sizeof(int)];
 			sigval_t _sigval;	/* same as below */
@@ -62,18 +62,18 @@ typedef struct siginfo {
 
 		/* POSIX.1b signals */
 		struct {
-			pid_t _pid;		/* sender's pid */
+			__kernel_pid_t _pid;	/* sender's pid */
 			__ARCH_SI_UID_T _uid;	/* sender's uid */
 			sigval_t _sigval;
 		} _rt;
 
 		/* SIGCHLD */
 		struct {
-			pid_t _pid;		/* which child */
+			__kernel_pid_t _pid;	/* which child */
 			__ARCH_SI_UID_T _uid;	/* sender's uid */
 			int _status;		/* exit code */
-			clock_t _utime;
-			clock_t _stime;
+			__kernel_clock_t _utime;
+			__kernel_clock_t _stime;
 		} _sigchld;
 
 		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
diff --git a/include/linux/agpgart.h b/include/linux/agpgart.h
index 110c600..f6778ec 100644
--- a/include/linux/agpgart.h
+++ b/include/linux/agpgart.h
@@ -77,20 +77,20 @@ typedef struct _agp_setup {
  * The "prot" down below needs still a "sleep" flag somehow ...
  */
 typedef struct _agp_segment {
-	off_t pg_start;		/* starting page to populate    */
-	size_t pg_count;	/* number of pages              */
-	int prot;		/* prot flags for mmap          */
+	__kernel_off_t pg_start;	/* starting page to populate    */
+	__kernel_size_t pg_count;	/* number of pages              */
+	int prot;			/* prot flags for mmap          */
 } agp_segment;
 
 typedef struct _agp_region {
-	pid_t pid;		/* pid of process               */
-	size_t seg_count;	/* number of segments           */
+	__kernel_pid_t pid;		/* pid of process       */
+	__kernel_size_t seg_count;	/* number of segments   */
 	struct _agp_segment *seg_list;
 } agp_region;
 
 typedef struct _agp_allocate {
 	int key;		/* tag of allocation            */
-	size_t pg_count;	/* number of pages              */
+	__kernel_size_t pg_count;/* number of pages             */
 	__u32 type;		/* 0 == normal, other devspec   */
    	__u32 physical;         /* device specific (some devices  
 				 * need a phys address of the     
@@ -100,7 +100,7 @@ typedef struct _agp_allocate {
 
 typedef struct _agp_bind {
 	int key;		/* tag of allocation            */
-	off_t pg_start;		/* starting page to populate    */
+	__kernel_off_t pg_start;/* starting page to populate    */
 } agp_bind;
 
 typedef struct _agp_unbind {
diff --git a/include/linux/cn_proc.h b/include/linux/cn_proc.h
index 1c86d65..b8125b2 100644
--- a/include/linux/cn_proc.h
+++ b/include/linux/cn_proc.h
@@ -65,20 +65,20 @@ struct proc_event {
 		} ack;
 
 		struct fork_proc_event {
-			pid_t parent_pid;
-			pid_t parent_tgid;
-			pid_t child_pid;
-			pid_t child_tgid;
+			__kernel_pid_t parent_pid;
+			__kernel_pid_t parent_tgid;
+			__kernel_pid_t child_pid;
+			__kernel_pid_t child_tgid;
 		} fork;
 
 		struct exec_proc_event {
-			pid_t process_pid;
-			pid_t process_tgid;
+			__kernel_pid_t process_pid;
+			__kernel_pid_t process_tgid;
 		} exec;
 
 		struct id_proc_event {
-			pid_t process_pid;
-			pid_t process_tgid;
+			__kernel_pid_t process_pid;
+			__kernel_pid_t process_tgid;
 			union {
 				__u32 ruid; /* task uid */
 				__u32 rgid; /* task gid */
@@ -90,8 +90,8 @@ struct proc_event {
 		} id;
 
 		struct exit_proc_event {
-			pid_t process_pid;
-			pid_t process_tgid;
+			__kernel_pid_t process_pid;
+			__kernel_pid_t process_tgid;
 			__u32 exit_code, exit_signal;
 		} exit;
 	} event_data;
diff --git a/include/linux/coda_psdev.h b/include/linux/coda_psdev.h
index 5b5d473..0c443c6 100644
--- a/include/linux/coda_psdev.h
+++ b/include/linux/coda_psdev.h
@@ -69,7 +69,6 @@ int venus_statfs(struct dentry *dentry, struct kstatfs *sfs);
  */
 
 extern struct venus_comm coda_comms[];
-#endif /* __KERNEL__ */
 
 /* messages between coda filesystem in kernel and Venus */
 struct upc_req {
@@ -88,4 +87,5 @@ struct upc_req {
 #define REQ_WRITE  0x4
 #define REQ_ABORT  0x8
 
+#endif /* __KERNEL__ */
 #endif
diff --git a/include/linux/cyclades.h b/include/linux/cyclades.h
index d06fbf2..788850b 100644
--- a/include/linux/cyclades.h
+++ b/include/linux/cyclades.h
@@ -82,9 +82,9 @@ struct cyclades_monitor {
  * open)
  */
 struct cyclades_idle_stats {
-    time_t	   in_use;	/* Time device has been in use (secs) */
-    time_t	   recv_idle;	/* Time since last char received (secs) */
-    time_t	   xmit_idle;	/* Time since last char transmitted (secs) */
+    __kernel_time_t in_use;	/* Time device has been in use (secs) */
+    __kernel_time_t recv_idle;	/* Time since last char received (secs) */
+    __kernel_time_t xmit_idle;	/* Time since last char transmitted (secs) */
     unsigned long  recv_bytes;	/* Bytes received */
     unsigned long  xmit_bytes;	/* Bytes transmitted */
     unsigned long  overruns;	/* Input overruns */
diff --git a/include/linux/dvb/video.h b/include/linux/dvb/video.h
index bd49c3e..ee5d2df 100644
--- a/include/linux/dvb/video.h
+++ b/include/linux/dvb/video.h
@@ -137,7 +137,7 @@ struct video_event {
 #define VIDEO_EVENT_FRAME_RATE_CHANGED	2
 #define VIDEO_EVENT_DECODER_STOPPED 	3
 #define VIDEO_EVENT_VSYNC 		4
-	time_t timestamp;
+	__kernel_time_t timestamp;
 	union {
 		video_size_t size;
 		unsigned int frame_rate;	/* in frames per 1000sec */
diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index 5ca54d7..c68e616 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -9,6 +9,7 @@
 #endif
 #include <linux/ptrace.h>
 
+#error this doesn't compile
 struct elf_siginfo
 {
 	int	si_signo;			/* signal number */
diff --git a/include/linux/if_pppol2tp.h b/include/linux/if_pppol2tp.h
index c7a6688..3a14b08 100644
--- a/include/linux/if_pppol2tp.h
+++ b/include/linux/if_pppol2tp.h
@@ -26,7 +26,7 @@
  */
 struct pppol2tp_addr
 {
-	pid_t	pid;			/* pid that owns the fd.
+	__kernel_pid_t	pid;		/* pid that owns the fd.
 					 * 0 => current */
 	int	fd;			/* FD of UDP socket to use */
 
diff --git a/include/linux/mroute6.h b/include/linux/mroute6.h
index 5375fac..43dc97e 100644
--- a/include/linux/mroute6.h
+++ b/include/linux/mroute6.h
@@ -65,7 +65,7 @@ struct mif6ctl {
 	mifi_t	mif6c_mifi;		/* Index of MIF */
 	unsigned char mif6c_flags;	/* MIFF_ flags */
 	unsigned char vifc_threshold;	/* ttl limit */
-	u_short	 mif6c_pifi;		/* the index of the physical IF */
+	__u16	 mif6c_pifi;		/* the index of the physical IF */
 	unsigned int vifc_rate_limit;	/* Rate limiter values (NI) */
 };
 
diff --git a/include/linux/netfilter_ipv4/ipt_owner.h b/include/linux/netfilter_ipv4/ipt_owner.h
index 92f4bda..60e941f 100644
--- a/include/linux/netfilter_ipv4/ipt_owner.h
+++ b/include/linux/netfilter_ipv4/ipt_owner.h
@@ -9,10 +9,10 @@
 #define IPT_OWNER_COMM	0x10
 
 struct ipt_owner_info {
-    uid_t uid;
-    gid_t gid;
-    pid_t pid;
-    pid_t sid;
+    __kernel_uid_t uid;
+    __kernel_gid_t gid;
+    __kernel_pid_t pid;
+    __kernel_pid_t sid;
     char comm[16];
     u_int8_t match, invert;	/* flags */
 };
diff --git a/include/linux/netfilter_ipv6/ip6t_owner.h b/include/linux/netfilter_ipv6/ip6t_owner.h
index 19937da..dc2cbcb 100644
--- a/include/linux/netfilter_ipv6/ip6t_owner.h
+++ b/include/linux/netfilter_ipv6/ip6t_owner.h
@@ -8,10 +8,10 @@
 #define IP6T_OWNER_SID	0x08
 
 struct ip6t_owner_info {
-    uid_t uid;
-    gid_t gid;
-    pid_t pid;
-    pid_t sid;
+    __kernel_uid_t uid;
+    __kernel_gid_t gid;
+    __kernel_pid_t pid;
+    __kernel_pid_t sid;
     u_int8_t match, invert;	/* flags */
 };
 
diff --git a/include/linux/pkt_sched.h b/include/linux/pkt_sched.h
index b2648e8..d51a2b3 100644
--- a/include/linux/pkt_sched.h
+++ b/include/linux/pkt_sched.h
@@ -515,7 +515,7 @@ enum
 
 struct tc_drr_stats
 {
-	u32	deficit;
+	__u32	deficit;
 };
 
 #endif
diff --git a/include/linux/ppp_defs.h b/include/linux/ppp_defs.h
index 1c866bd..0f93ed6 100644
--- a/include/linux/ppp_defs.h
+++ b/include/linux/ppp_defs.h
@@ -177,8 +177,8 @@ struct ppp_comp_stats {
  * the last NP packet was sent or received.
  */
 struct ppp_idle {
-    time_t xmit_idle;		/* time since last NP packet sent */
-    time_t recv_idle;		/* time since last NP packet received */
+    __kernel_time_t xmit_idle;	/* time since last NP packet sent */
+    __kernel_time_t recv_idle;	/* time since last NP packet received */
 };
 
 #endif /* _PPP_DEFS_H_ */
diff --git a/include/linux/suspend_ioctls.h b/include/linux/suspend_ioctls.h
index 2c6faec..40d4605 100644
--- a/include/linux/suspend_ioctls.h
+++ b/include/linux/suspend_ioctls.h
@@ -7,8 +7,8 @@
  * SNAPSHOT_SET_SWAP_AREA ioctl
  */
 struct resume_swap_area {
-	loff_t offset;
-	u_int32_t dev;
+	__kernel_loff_t offset;
+	__u32 dev;
 } __attribute__((packed));
 
 #define SNAPSHOT_IOC_MAGIC	'3'
@@ -20,13 +20,13 @@ struct resume_swap_area {
 #define SNAPSHOT_S2RAM			_IO(SNAPSHOT_IOC_MAGIC, 11)
 #define SNAPSHOT_SET_SWAP_AREA		_IOW(SNAPSHOT_IOC_MAGIC, 13, \
 							struct resume_swap_area)
-#define SNAPSHOT_GET_IMAGE_SIZE		_IOR(SNAPSHOT_IOC_MAGIC, 14, loff_t)
+#define SNAPSHOT_GET_IMAGE_SIZE		_IOR(SNAPSHOT_IOC_MAGIC, 14, __kernel_loff_t)
 #define SNAPSHOT_PLATFORM_SUPPORT	_IO(SNAPSHOT_IOC_MAGIC, 15)
 #define SNAPSHOT_POWER_OFF		_IO(SNAPSHOT_IOC_MAGIC, 16)
 #define SNAPSHOT_CREATE_IMAGE		_IOW(SNAPSHOT_IOC_MAGIC, 17, int)
 #define SNAPSHOT_PREF_IMAGE_SIZE	_IO(SNAPSHOT_IOC_MAGIC, 18)
-#define SNAPSHOT_AVAIL_SWAP_SIZE	_IOR(SNAPSHOT_IOC_MAGIC, 19, loff_t)
-#define SNAPSHOT_ALLOC_SWAP_PAGE	_IOR(SNAPSHOT_IOC_MAGIC, 20, loff_t)
+#define SNAPSHOT_AVAIL_SWAP_SIZE	_IOR(SNAPSHOT_IOC_MAGIC, 19, __kernel_loff_t)
+#define SNAPSHOT_ALLOC_SWAP_PAGE	_IOR(SNAPSHOT_IOC_MAGIC, 20, __kernel_loff_t)
 #define SNAPSHOT_IOC_MAXNR	20
 
 #endif /* _LINUX_SUSPEND_IOCTLS_H */
diff --git a/include/linux/time.h b/include/linux/time.h
index fbbd2a1..242f624 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -12,14 +12,14 @@
 #ifndef _STRUCT_TIMESPEC
 #define _STRUCT_TIMESPEC
 struct timespec {
-	time_t	tv_sec;		/* seconds */
-	long	tv_nsec;	/* nanoseconds */
+	__kernel_time_t	tv_sec;			/* seconds */
+	long		tv_nsec;		/* nanoseconds */
 };
 #endif
 
 struct timeval {
-	time_t		tv_sec;		/* seconds */
-	suseconds_t	tv_usec;	/* microseconds */
+	__kernel_time_t		tv_sec;		/* seconds */
+	__kernel_suseconds_t	tv_usec;	/* microseconds */
 };
 
 struct timezone {
diff --git a/include/linux/times.h b/include/linux/times.h
index e2d3020..87b6261 100644
--- a/include/linux/times.h
+++ b/include/linux/times.h
@@ -4,10 +4,10 @@
 #include <linux/types.h>
 
 struct tms {
-	clock_t tms_utime;
-	clock_t tms_stime;
-	clock_t tms_cutime;
-	clock_t tms_cstime;
+	__kernel_clock_t tms_utime;
+	__kernel_clock_t tms_stime;
+	__kernel_clock_t tms_cutime;
+	__kernel_clock_t tms_cstime;
 };
 
 #endif
diff --git a/include/linux/utime.h b/include/linux/utime.h
index 640be6a..5cdf673 100644
--- a/include/linux/utime.h
+++ b/include/linux/utime.h
@@ -4,8 +4,8 @@
 #include <linux/types.h>
 
 struct utimbuf {
-	time_t actime;
-	time_t modtime;
+	__kernel_time_t actime;
+	__kernel_time_t modtime;
 };
 
 #endif
diff --git a/include/linux/xfrm.h b/include/linux/xfrm.h
index 52f3abd..a58fe2b 100644
--- a/include/linux/xfrm.h
+++ b/include/linux/xfrm.h
@@ -58,7 +58,7 @@ struct xfrm_selector
 	__u8	prefixlen_s;
 	__u8	proto;
 	int	ifindex;
-	uid_t	user;
+	__kernel_uid_t	user;
 };
 
 #define XFRM_INF (~(__u64)0)
diff --git a/include/mtd/mtd-abi.h b/include/mtd/mtd-abi.h
index c6c61cd..fb67201 100644
--- a/include/mtd/mtd-abi.h
+++ b/include/mtd/mtd-abi.h
@@ -84,8 +84,8 @@ struct otp_info {
 #define MEMGETREGIONINFO	_IOWR('M', 8, struct region_info_user)
 #define MEMSETOOBSEL		_IOW('M', 9, struct nand_oobinfo)
 #define MEMGETOOBSEL		_IOR('M', 10, struct nand_oobinfo)
-#define MEMGETBADBLOCK		_IOW('M', 11, loff_t)
-#define MEMSETBADBLOCK		_IOW('M', 12, loff_t)
+#define MEMGETBADBLOCK		_IOW('M', 11, __kernel_loff_t)
+#define MEMSETBADBLOCK		_IOW('M', 12, __kernel_loff_t)
 #define OTPSELECT		_IOR('M', 13, int)
 #define OTPGETREGIONCOUNT	_IOW('M', 14, int)
 #define OTPGETREGIONINFO	_IOW('M', 15, struct otp_info)
diff --git a/include/sound/asound.h b/include/sound/asound.h
index 1c02ed1..16684c5 100644
--- a/include/sound/asound.h
+++ b/include/sound/asound.h
@@ -385,7 +385,7 @@ struct snd_pcm_sw_params {
 
 struct snd_pcm_channel_info {
 	unsigned int channel;
-	off_t offset;			/* mmap offset */
+	__kernel_off_t offset;		/* mmap offset */
 	unsigned int first;		/* offset to first sample in bits */
 	unsigned int step;		/* samples distance in bits */
 };
@@ -789,7 +789,7 @@ struct snd_ctl_elem_info {
 	snd_ctl_elem_type_t type;	/* R: value type - SNDRV_CTL_ELEM_TYPE_* */
 	unsigned int access;		/* R: value access (bitmask) - SNDRV_CTL_ELEM_ACCESS_* */
 	unsigned int count;		/* count of values */
-	pid_t owner;			/* owner's PID of this control */
+	__kernel_pid_t owner;		/* owner's PID of this control */
 	union {
 		struct {
 			long min;		/* R: minimum value */
