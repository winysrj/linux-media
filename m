Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:37977 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaADRIm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 12:08:42 -0500
Received: by mail-ee0-f43.google.com with SMTP id c13so7128884eek.16
        for <linux-media@vger.kernel.org>; Sat, 04 Jan 2014 09:08:41 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 02/11] libdvbv5: add attribute packed to structs and unions
Date: Sat,  4 Jan 2014 18:07:52 +0100
Message-Id: <1388855282-19295-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388855282-19295-1-git-send-email-neolynx@gmail.com>
References: <1388855282-19295-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/atsc_header.h                |    2 +-
 lib/include/libdvbv5/desc_atsc_service_location.h |    4 ++--
 lib/include/libdvbv5/desc_cable_delivery.h        |    8 ++++----
 lib/include/libdvbv5/desc_event_extended.h        |    4 ++--
 lib/include/libdvbv5/desc_frequency_list.h        |    4 ++--
 lib/include/libdvbv5/desc_isdbt_delivery.h        |    4 ++--
 lib/include/libdvbv5/desc_logical_channel.h       |    4 ++--
 lib/include/libdvbv5/desc_sat.h                   |    4 ++--
 lib/include/libdvbv5/desc_service_location.h      |    8 ++++----
 lib/include/libdvbv5/desc_t2_delivery.h           |    4 ++--
 lib/include/libdvbv5/header.h                     |    4 ++--
 lib/include/libdvbv5/mpeg_es.h                    |    6 +++---
 lib/include/libdvbv5/mpeg_ts.h                    |    2 +-
 lib/include/libdvbv5/nit.h                        |    4 ++--
 lib/include/libdvbv5/pat.h                        |    2 +-
 lib/include/libdvbv5/pmt.h                        |   16 ++++++++--------
 lib/include/libdvbv5/sdt.h                        |    2 +-
 lib/include/libdvbv5/vct.h                        |    4 ++--
 18 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/lib/include/libdvbv5/atsc_header.h b/lib/include/libdvbv5/atsc_header.h
index 1e7148e..9685b37 100644
--- a/lib/include/libdvbv5/atsc_header.h
+++ b/lib/include/libdvbv5/atsc_header.h
@@ -36,7 +36,7 @@ struct atsc_table_header {
 			uint16_t priv:1;
 			uint16_t syntax:1;
 		} __attribute__((packed));
-	};
+	} __attribute__((packed));
 	uint16_t id;
 	uint8_t  current_next:1;
 	uint8_t  version:5;
diff --git a/lib/include/libdvbv5/desc_atsc_service_location.h b/lib/include/libdvbv5/desc_atsc_service_location.h
index 47113f2..1ff2341 100644
--- a/lib/include/libdvbv5/desc_atsc_service_location.h
+++ b/lib/include/libdvbv5/desc_atsc_service_location.h
@@ -32,7 +32,7 @@ struct atsc_desc_service_location_elementary {
 			uint16_t elementary_pid:13;
 			uint16_t reserved:3;
 		} __attribute__((packed));
-	};
+	} __attribute__((packed));
 	char ISO_639_language_code[3];
 } __attribute__((packed));
 
@@ -49,7 +49,7 @@ struct atsc_desc_service_location {
 			uint16_t pcr_pid:13;
 			uint16_t reserved:3;
 		} __attribute__((packed));
-	};
+	} __attribute__((packed));
 
 	uint8_t number_elements;
 } __attribute__((packed));
diff --git a/lib/include/libdvbv5/desc_cable_delivery.h b/lib/include/libdvbv5/desc_cable_delivery.h
index 70f5a5b..c2bab5a 100644
--- a/lib/include/libdvbv5/desc_cable_delivery.h
+++ b/lib/include/libdvbv5/desc_cable_delivery.h
@@ -37,16 +37,16 @@ struct dvb_desc_cable_delivery {
 		struct {
 			uint16_t fec_outer:4;
 			uint16_t reserved_future_use:12;
-		};
-	};
+		} __attribute__((packed));
+	} __attribute__((packed));
 	uint8_t modulation;
 	union {
 		uint32_t bitfield2;
 		struct {
 			uint32_t fec_inner:4;
 			uint32_t symbol_rate:28;
-		};
-	};
+		} __attribute__((packed));
+	} __attribute__((packed));
 } __attribute__((packed));
 
 struct dvb_v5_fe_parms;
diff --git a/lib/include/libdvbv5/desc_event_extended.h b/lib/include/libdvbv5/desc_event_extended.h
index a543590..03fb1f1 100644
--- a/lib/include/libdvbv5/desc_event_extended.h
+++ b/lib/include/libdvbv5/desc_event_extended.h
@@ -34,9 +34,9 @@ struct dvb_desc_event_extended {
 		struct {
 			uint8_t last_id:4;
 			uint8_t id:4;
-		};
+		} __attribute__((packed));
 		uint8_t ids;
-	};
+	} __attribute__((packed));
 
 	unsigned char language[4];
 	char *text;
diff --git a/lib/include/libdvbv5/desc_frequency_list.h b/lib/include/libdvbv5/desc_frequency_list.h
index e6e7945..55723c7 100644
--- a/lib/include/libdvbv5/desc_frequency_list.h
+++ b/lib/include/libdvbv5/desc_frequency_list.h
@@ -38,8 +38,8 @@ struct dvb_desc_frequency_list {
 		struct {
 			uint8_t freq_type:2;
 			uint8_t reserved:6;
-		};
-	};
+		} __attribute__((packed));
+	} __attribute__((packed));
 } __attribute__((packed));
 
 struct dvb_v5_fe_parms;
diff --git a/lib/include/libdvbv5/desc_isdbt_delivery.h b/lib/include/libdvbv5/desc_isdbt_delivery.h
index 4df30df..5bac178 100644
--- a/lib/include/libdvbv5/desc_isdbt_delivery.h
+++ b/lib/include/libdvbv5/desc_isdbt_delivery.h
@@ -38,8 +38,8 @@ struct isdbt_desc_terrestrial_delivery_system {
 			uint16_t transmission_mode:2;
 			uint16_t guard_interval:2;
 			uint16_t area_code:6;
-		};
-	};
+		} __attribute__((packed));
+	} __attribute__((packed));
 } __attribute__((packed));
 
 struct dvb_v5_fe_parms;
diff --git a/lib/include/libdvbv5/desc_logical_channel.h b/lib/include/libdvbv5/desc_logical_channel.h
index ce1206c..bbccb81 100644
--- a/lib/include/libdvbv5/desc_logical_channel.h
+++ b/lib/include/libdvbv5/desc_logical_channel.h
@@ -36,8 +36,8 @@ struct dvb_desc_logical_channel_number {
 			uint16_t logical_channel_number:10;
 			uint16_t reserved:5;
 			uint16_t visible_service_flag:1;
-		};
-	};
+		} __attribute__((packed));
+	} __attribute__((packed));
 } __attribute__((packed));
 
 struct dvb_desc_logical_channel {
diff --git a/lib/include/libdvbv5/desc_sat.h b/lib/include/libdvbv5/desc_sat.h
index bb55319..9e192c6 100644
--- a/lib/include/libdvbv5/desc_sat.h
+++ b/lib/include/libdvbv5/desc_sat.h
@@ -42,8 +42,8 @@ struct dvb_desc_sat {
 		struct {
 			uint32_t fec:4;
 			uint32_t symbol_rate:28;
-		};
-	};
+		} __attribute__((packed));
+	} __attribute__((packed));
 } __attribute__((packed));
 
 struct dvb_v5_fe_parms;
diff --git a/lib/include/libdvbv5/desc_service_location.h b/lib/include/libdvbv5/desc_service_location.h
index 89ed055..046bedc 100644
--- a/lib/include/libdvbv5/desc_service_location.h
+++ b/lib/include/libdvbv5/desc_service_location.h
@@ -31,8 +31,8 @@ struct dvb_desc_service_location_element {
 		struct {
 			uint16_t elementary_pid:13;
 			uint16_t reserved:3;
-		};
-	};
+		} __attribute__((packed));
+	} __attribute__((packed));
 	uint8_t language[4];
 } __attribute__((packed));
 
@@ -46,8 +46,8 @@ struct dvb_desc_service_location {
 		struct {
 			uint16_t pcr_pid:13;
 			uint16_t reserved:3;
-		};
-	};
+		} __attribute__((packed));
+	} __attribute__((packed));
 	uint8_t elements;
 	struct dvb_desc_service_location_element *element;
 } __attribute__((packed));
diff --git a/lib/include/libdvbv5/desc_t2_delivery.h b/lib/include/libdvbv5/desc_t2_delivery.h
index a36f6c1..a51f897 100644
--- a/lib/include/libdvbv5/desc_t2_delivery.h
+++ b/lib/include/libdvbv5/desc_t2_delivery.h
@@ -43,8 +43,8 @@ struct dvb_desc_t2_delivery {
 			uint16_t reserved:2;
 			uint16_t bandwidth:3;
 			uint16_t SISO_MISO:2;
-		};
-	};
+		} __attribute__((packed));
+	} __attribute__((packed));
 
 	uint32_t *centre_frequency;
 	uint8_t frequency_loop_length;
diff --git a/lib/include/libdvbv5/header.h b/lib/include/libdvbv5/header.h
index c8cd466..39871c9 100644
--- a/lib/include/libdvbv5/header.h
+++ b/lib/include/libdvbv5/header.h
@@ -35,7 +35,7 @@ struct dvb_ts_packet_header {
 			uint16_t payload_unit_start_indicator:1;
 			uint16_t transport_error_indicator:1;
 		} __attribute__((packed));
-	};
+	} __attribute__((packed));
 	uint8_t continuity_counter:4;
 	uint8_t adaptation_field_control:2;
 	uint8_t transport_scrambling_control:2;
@@ -55,7 +55,7 @@ struct dvb_table_header {
 			uint8_t  zero2:1;
 			uint8_t  syntax:1;
 		} __attribute__((packed));
-	};
+	} __attribute__((packed));
 	uint16_t id;
 	uint8_t  current_next:1;
 	uint8_t  version:5;
diff --git a/lib/include/libdvbv5/mpeg_es.h b/lib/include/libdvbv5/mpeg_es.h
index 4c6a862..4f1786e 100644
--- a/lib/include/libdvbv5/mpeg_es.h
+++ b/lib/include/libdvbv5/mpeg_es.h
@@ -47,7 +47,7 @@ struct dvb_mpeg_es_seq_start {
 			uint32_t height:12;
 			uint32_t width:12;
 		} __attribute__((packed));
-	};
+	} __attribute__((packed));
 	union {
 		uint32_t bitfield3;
 		struct {
@@ -58,7 +58,7 @@ struct dvb_mpeg_es_seq_start {
 			uint32_t one:1;
 			uint32_t bitrate:18;
 		} __attribute__((packed));
-	};
+	} __attribute__((packed));
 } __attribute__((packed));
 
 struct dvb_mpeg_es_pic_start {
@@ -77,7 +77,7 @@ struct dvb_mpeg_es_pic_start {
 			uint32_t coding_type:3;
 			uint32_t temporal_ref:10;
 		} __attribute__((packed));
-	};
+	} __attribute__((packed));
 } __attribute__((packed));
 
 enum dvb_mpeg_es_frame_t
diff --git a/lib/include/libdvbv5/mpeg_ts.h b/lib/include/libdvbv5/mpeg_ts.h
index de4fc3f..a877f42 100644
--- a/lib/include/libdvbv5/mpeg_ts.h
+++ b/lib/include/libdvbv5/mpeg_ts.h
@@ -51,7 +51,7 @@ struct dvb_mpeg_ts {
 			uint16_t payload_start:1;
 			uint16_t tei:1;
 		} __attribute__((packed));
-	};
+	} __attribute__((packed));
 	struct {
 		uint8_t continuity_counter:4;
 		uint8_t adaptation_field:2;
diff --git a/lib/include/libdvbv5/nit.h b/lib/include/libdvbv5/nit.h
index 09fe596..48feecc 100644
--- a/lib/include/libdvbv5/nit.h
+++ b/lib/include/libdvbv5/nit.h
@@ -49,7 +49,7 @@ struct dvb_table_nit_transport {
 			uint16_t section_length:12;
 			uint16_t reserved:4;
 		} __attribute__((packed));
-	};
+	} __attribute__((packed));
 	struct dvb_desc *descriptor;
 	struct dvb_table_nit_transport *next;
 } __attribute__((packed));
@@ -62,7 +62,7 @@ struct dvb_table_nit {
 			uint16_t desc_length:12;
 			uint16_t reserved:4;
 		} __attribute__((packed));
-	};
+	} __attribute__((packed));
 	struct dvb_desc *descriptor;
 	struct dvb_table_nit_transport *transport;
 } __attribute__((packed));
diff --git a/lib/include/libdvbv5/pat.h b/lib/include/libdvbv5/pat.h
index 899815c..2004836 100644
--- a/lib/include/libdvbv5/pat.h
+++ b/lib/include/libdvbv5/pat.h
@@ -38,7 +38,7 @@ struct dvb_table_pat_program {
 			uint16_t pid:13;
 			uint8_t  reserved:3;
 		} __attribute__((packed));
-	};
+	} __attribute__((packed));
 	struct dvb_table_pat_program *next;
 } __attribute__((packed));
 
diff --git a/lib/include/libdvbv5/pmt.h b/lib/include/libdvbv5/pmt.h
index e1d44cb..f1b7cef 100644
--- a/lib/include/libdvbv5/pmt.h
+++ b/lib/include/libdvbv5/pmt.h
@@ -64,16 +64,16 @@ struct dvb_table_pmt_stream {
 		struct {
 			uint16_t elementary_pid:13;
 			uint16_t reserved:3;
-		};
-	};
+		} __attribute__((packed));
+	} __attribute__((packed));
 	union {
 		uint16_t bitfield2;
 		struct {
 			uint16_t section_length:10;
 			uint16_t zero:2;
 			uint16_t reserved2:4;
-		};
-	};
+		} __attribute__((packed));
+	} __attribute__((packed));
 	struct dvb_desc *descriptor;
 	struct dvb_table_pmt_stream *next;
 } __attribute__((packed));
@@ -85,8 +85,8 @@ struct dvb_table_pmt {
 		struct {
 			uint16_t pcr_pid:13;
 			uint16_t reserved2:3;
-		};
-	};
+		} __attribute__((packed));
+	} __attribute__((packed));
 
 	union {
 		uint16_t bitfield2;
@@ -94,8 +94,8 @@ struct dvb_table_pmt {
 			uint16_t prog_length:10;
 			uint16_t zero3:2;
 			uint16_t reserved3:4;
-		};
-	};
+		} __attribute__((packed));
+	} __attribute__((packed));
 	struct dvb_table_pmt_stream *stream;
 } __attribute__((packed));
 
diff --git a/lib/include/libdvbv5/sdt.h b/lib/include/libdvbv5/sdt.h
index 77ec5b1..17c51f2 100644
--- a/lib/include/libdvbv5/sdt.h
+++ b/lib/include/libdvbv5/sdt.h
@@ -44,7 +44,7 @@ struct dvb_table_sdt_service {
 			uint16_t free_CA_mode:1;
 			uint16_t running_status:3;
 		} __attribute__((packed));
-	};
+	} __attribute__((packed));
 	struct dvb_desc *descriptor;
 	struct dvb_table_sdt_service *next;
 } __attribute__((packed));
diff --git a/lib/include/libdvbv5/vct.h b/lib/include/libdvbv5/vct.h
index 6935f30..0dc64fd 100644
--- a/lib/include/libdvbv5/vct.h
+++ b/lib/include/libdvbv5/vct.h
@@ -104,8 +104,8 @@ union atsc_table_vct_descriptor_length {
 	struct {
 		uint16_t descriptor_length:10;
 		uint16_t reserved:6;
-	};
-};
+	} __attribute__((packed));
+} __attribute__((packed));
 
 #define atsc_vct_channel_foreach(_channel, _vct) \
 	for (struct atsc_table_vct_channel *_channel = _vct->channel; _channel; _channel = _channel->next) \
-- 
1.7.10.4

