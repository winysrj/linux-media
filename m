Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47661 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987Ab2GFTX6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 15:23:58 -0400
Received: by mail-wi0-f178.google.com with SMTP id hr14so1171001wib.1
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 12:23:57 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 3/5] libdvbv5: New DVB table parsing
Date: Fri,  6 Jul 2012 21:23:10 +0200
Message-Id: <1341602592-29508-3-git-send-email-neolynx@gmail.com>
In-Reply-To: <1341602592-29508-1-git-send-email-neolynx@gmail.com>
References: <1341602592-29508-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors.h                          |  393 ++++++++
 lib/include/descriptors/desc_cable_delivery.h      |   64 ++
 lib/include/descriptors/desc_frequency_list.h      |   57 ++
 lib/include/descriptors/desc_language.h            |   50 +
 lib/include/descriptors/desc_network_name.h        |   49 +
 lib/include/descriptors/desc_sat.h                 |   62 ++
 lib/include/descriptors/desc_service.h             |   51 ++
 lib/include/descriptors/desc_service_list.h        |   54 ++
 .../descriptors/desc_terrestrial_delivery.h        |   62 ++
 lib/include/descriptors/header.h                   |   62 ++
 lib/include/descriptors/nit.h                      |   86 ++
 lib/include/descriptors/pat.h                      |   63 ++
 lib/include/descriptors/pmt.h                      |   90 ++
 lib/include/descriptors/sdt.h                      |   74 ++
 lib/include/dvb-demux.h                            |   11 +
 lib/include/dvb-fe.h                               |   32 +-
 lib/include/dvb-file.h                             |    6 +-
 lib/include/dvb-log.h                              |   49 +
 lib/include/dvb-scan.h                             |  120 +---
 lib/libdvbv5/Makefile.am                           |   20 +-
 lib/libdvbv5/crc32.c                               |   76 ++
 lib/libdvbv5/crc32.h                               |   31 +
 lib/libdvbv5/descriptors.c                         |  946 +++++++++++---------
 lib/libdvbv5/descriptors.h                         |  214 -----
 lib/libdvbv5/descriptors/desc_cable_delivery.c     |   53 ++
 lib/libdvbv5/descriptors/desc_frequency_list.c     |   63 ++
 lib/libdvbv5/descriptors/desc_language.c           |   44 +
 lib/libdvbv5/descriptors/desc_network_name.c       |   41 +
 lib/libdvbv5/descriptors/desc_sat.c                |   69 ++
 lib/libdvbv5/descriptors/desc_service.c            |   56 ++
 lib/libdvbv5/descriptors/desc_service_list.c       |   53 ++
 .../descriptors/desc_terrestrial_delivery.c        |   57 ++
 lib/libdvbv5/descriptors/header.c                  |   48 +
 lib/libdvbv5/descriptors/nit.c                     |  100 ++
 lib/libdvbv5/descriptors/pat.c                     |   57 ++
 lib/libdvbv5/descriptors/pmt.c                     |  103 +++
 lib/libdvbv5/descriptors/sdt.c                     |   88 ++
 lib/libdvbv5/dvb-demux.c                           |   18 +-
 lib/libdvbv5/dvb-fe.c                              |   54 +-
 lib/libdvbv5/dvb-file.c                            |   10 +-
 lib/libdvbv5/dvb-log.c                             |   63 ++
 lib/libdvbv5/dvb-scan.c                            |  328 ++++---
 utils/dvb/dvb-fe-tool.c                            |    2 +-
 utils/dvb/dvbv5-scan.c                             |    8 +-
 utils/v4l2-compliance/v4l2-test-formats.cpp        |   10 +-
 45 files changed, 3057 insertions(+), 990 deletions(-)
 create mode 100644 lib/include/descriptors.h
 create mode 100644 lib/include/descriptors/desc_cable_delivery.h
 create mode 100644 lib/include/descriptors/desc_frequency_list.h
 create mode 100644 lib/include/descriptors/desc_language.h
 create mode 100644 lib/include/descriptors/desc_network_name.h
 create mode 100644 lib/include/descriptors/desc_sat.h
 create mode 100644 lib/include/descriptors/desc_service.h
 create mode 100644 lib/include/descriptors/desc_service_list.h
 create mode 100644 lib/include/descriptors/desc_terrestrial_delivery.h
 create mode 100644 lib/include/descriptors/header.h
 create mode 100644 lib/include/descriptors/nit.h
 create mode 100644 lib/include/descriptors/pat.h
 create mode 100644 lib/include/descriptors/pmt.h
 create mode 100644 lib/include/descriptors/sdt.h
 create mode 100644 lib/include/dvb-log.h
 create mode 100644 lib/libdvbv5/crc32.c
 create mode 100644 lib/libdvbv5/crc32.h
 delete mode 100644 lib/libdvbv5/descriptors.h
 create mode 100644 lib/libdvbv5/descriptors/desc_cable_delivery.c
 create mode 100644 lib/libdvbv5/descriptors/desc_frequency_list.c
 create mode 100644 lib/libdvbv5/descriptors/desc_language.c
 create mode 100644 lib/libdvbv5/descriptors/desc_network_name.c
 create mode 100644 lib/libdvbv5/descriptors/desc_sat.c
 create mode 100644 lib/libdvbv5/descriptors/desc_service.c
 create mode 100644 lib/libdvbv5/descriptors/desc_service_list.c
 create mode 100644 lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
 create mode 100644 lib/libdvbv5/descriptors/header.c
 create mode 100644 lib/libdvbv5/descriptors/nit.c
 create mode 100644 lib/libdvbv5/descriptors/pat.c
 create mode 100644 lib/libdvbv5/descriptors/pmt.c
 create mode 100644 lib/libdvbv5/descriptors/sdt.c
 create mode 100644 lib/libdvbv5/dvb-log.c

diff --git a/lib/include/descriptors.h b/lib/include/descriptors.h
new file mode 100644
index 0000000..8ecb13d
--- /dev/null
+++ b/lib/include/descriptors.h
@@ -0,0 +1,393 @@
+  /*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ */
+
+/*
+ * Descriptors, as defined on ETSI EN 300 468 V1.11.1 (2010-04)
+ */
+
+
+#ifndef _DESCRIPTORS_H
+#define _DESCRIPTORS_H
+
+#include <endian.h>
+#include <unistd.h>
+#include <stdint.h>
+
+#define DVB_MAX_PAYLOAD_PACKET_SIZE 4096
+#define DVB_PID_SDT      17
+#define DVB_PMT_TABLE_ID 2
+
+struct dvb_v5_fe_parms;
+
+typedef void *(*dvb_table_init_func)(struct dvb_v5_fe_parms *parms, const uint8_t *ptr, ssize_t size);
+
+struct dvb_table_init {
+	dvb_table_init_func init;
+};
+
+extern const struct dvb_table_init dvb_table_initializers[];
+
+#define bswap16(b) do {\
+	b = be16toh(b); \
+} while (0)
+
+#define bswap32(b) do {\
+	b = be32toh(b); \
+} while (0)
+
+struct dvb_desc {
+	uint8_t type;
+	struct dvb_desc *next;
+	uint8_t length;
+	uint8_t data[];
+} __attribute__((packed));
+
+#define dvb_desc_foreach( _desc, _tbl ) \
+	for( struct dvb_desc *_desc = _tbl->descriptor; _desc; _desc = _desc->next ) \
+
+#define dvb_desc_find(_struct, _desc, _tbl, _type) \
+	for( _struct *_desc = (_struct *) _tbl->descriptor; _desc; _desc = (_struct *) _desc->next ) \
+		if(_desc->type == _type) \
+
+ssize_t dvb_desc_init(const uint8_t *buf, struct dvb_desc *desc);
+
+uint32_t bcd(uint32_t bcd);
+
+ssize_t dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf, uint8_t *dest, uint16_t section_length, struct dvb_desc **head_desc);
+
+struct dvb_v5_fe_parms;
+
+typedef ssize_t (*dvb_desc_init_func)(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+typedef void (*dvb_desc_print_func)(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+
+struct dvb_descriptor {
+	const char *name;
+	dvb_desc_init_func init;
+	dvb_desc_print_func print;
+	ssize_t desc_size;
+};
+
+extern const struct dvb_descriptor dvb_descriptors[];
+
+enum dvb_tables {
+	PAT,
+	PMT,
+	NIT,
+	SDT,
+};
+
+enum descriptors {
+	/* ISO/IEC 13818-1 */
+	video_stream_descriptor				= 0x02,
+	audio_stream_descriptor				= 0x03,
+	hierarchy_descriptor				= 0x04,
+	dvbpsi_registration_descriptor			= 0x05,
+	ds_alignment_descriptor				= 0x06,
+	target_background_grid_descriptor		= 0x07,
+	video_window_descriptor				= 0x08,
+	conditional_access_descriptor			= 0x09,
+	iso639_language_descriptor			= 0x0a,
+	system_clock_descriptor				= 0x0b,
+	multiplex_buffer_utilization_descriptor		= 0x0c,
+	copyright_descriptor				= 0x0d,
+	maximum_bitrate_descriptor			= 0x0e,
+	private_data_indicator_descriptor		= 0x0f,
+	smoothing_buffer_descriptor			= 0x10,
+	std_descriptor					= 0x11,
+	ibp_descriptor					= 0x12,
+
+	mpeg4_video_descriptor				= 0x1b,
+	mpeg4_audio_descriptor				= 0x1c,
+	iod_descriptor					= 0x1d,
+	sl_descriptor					= 0x1e,
+	fmc_descriptor					= 0x1f,
+	external_es_id_descriptor			= 0x20,
+	muxcode_descriptor				= 0x21,
+	fmxbuffersize_descriptor			= 0x22,
+	multiplexbuffer_descriptor			= 0x23,
+	content_labeling_descriptor			= 0x24,
+	metadata_pointer_descriptor			= 0x25,
+	metadata_descriptor				= 0x26,
+	metadata_std_descriptor				= 0x27,
+	AVC_video_descriptor				= 0x28,
+	ipmp_descriptor					= 0x29,
+	AVC_timing_and_HRD_descriptor			= 0x2a,
+	mpeg2_aac_audio_descriptor			= 0x2b,
+	flexmux_timing_descriptor			= 0x2c,
+
+	/* ETSI EN 300 468 V1.11.1 (2010-04) */
+
+	network_name_descriptor				= 0x40,
+	service_list_descriptor				= 0x41,
+	stuffing_descriptor				= 0x42,
+	satellite_delivery_system_descriptor		= 0x43,
+	cable_delivery_system_descriptor		= 0x44,
+	VBI_data_descriptor				= 0x45,
+	VBI_teletext_descriptor				= 0x46,
+	bouquet_name_descriptor				= 0x47,
+	service_descriptor				= 0x48,
+	country_availability_descriptor			= 0x49,
+	linkage_descriptor				= 0x4a,
+	NVOD_reference_descriptor			= 0x4b,
+	time_shifted_service_descriptor			= 0x4c,
+	short_event_descriptor				= 0x4d,
+	extended_event_descriptor			= 0x4e,
+	time_shifted_event_descriptor			= 0x4f,
+	component_descriptor				= 0x50,
+	mosaic_descriptor				= 0x51,
+	stream_identifier_descriptor			= 0x52,
+	CA_identifier_descriptor			= 0x53,
+	content_descriptor				= 0x54,
+	parental_rating_descriptor			= 0x55,
+	teletext_descriptor				= 0x56,
+	telephone_descriptor				= 0x57,
+	local_time_offset_descriptor			= 0x58,
+	subtitling_descriptor				= 0x59,
+	terrestrial_delivery_system_descriptor		= 0x5a,
+	multilingual_network_name_descriptor		= 0x5b,
+	multilingual_bouquet_name_descriptor		= 0x5c,
+	multilingual_service_name_descriptor		= 0x5d,
+	multilingual_component_descriptor		= 0x5e,
+	private_data_specifier_descriptor		= 0x5f,
+	service_move_descriptor				= 0x60,
+	short_smoothing_buffer_descriptor		= 0x61,
+	frequency_list_descriptor			= 0x62,
+	partial_transport_stream_descriptor		= 0x63,
+	data_broadcast_descriptor			= 0x64,
+	scrambling_descriptor				= 0x65,
+	data_broadcast_id_descriptor			= 0x66,
+	transport_stream_descriptor			= 0x67,
+	DSNG_descriptor					= 0x68,
+	PDC_descriptor					= 0x69,
+	AC_3_descriptor					= 0x6a,
+	ancillary_data_descriptor			= 0x6b,
+	cell_list_descriptor				= 0x6c,
+	cell_frequency_link_descriptor			= 0x6d,
+	announcement_support_descriptor			= 0x6e,
+	application_signalling_descriptor		= 0x6f,
+	adaptation_field_data_descriptor		= 0x70,
+	service_identifier_descriptor			= 0x71,
+	service_availability_descriptor			= 0x72,
+	default_authority_descriptor			= 0x73,
+	related_content_descriptor			= 0x74,
+	TVA_id_descriptor				= 0x75,
+	content_identifier_descriptor			= 0x76,
+	time_slice_fec_identifier_descriptor		= 0x77,
+	ECM_repetition_rate_descriptor			= 0x78,
+	S2_satellite_delivery_system_descriptor		= 0x79,
+	enhanced_AC_3_descriptor			= 0x7a,
+	DTS_descriptor					= 0x7b,
+	AAC_descriptor					= 0x7c,
+	XAIT_location_descriptor			= 0x7d,
+	FTA_content_management_descriptor		= 0x7e,
+	extension_descriptor				= 0x7f,
+
+	/* SCTE 35 2004 */
+	CUE_identifier_descriptor			= 0x8a,
+
+	/* From http://www.etherguidesystems.com/Help/SDOs/ATSC/Semantics/Descriptors/Default.aspx */
+	component_name_descriptor			= 0xa3,
+
+	/* From http://www.coolstf.com/tsreader/descriptors.html */
+	logical_channel_number_descriptor		= 0x83,
+
+	/* ISDB Descriptors, as defined on ABNT NBR 15603-1 2007 */
+
+	carousel_id_descriptor				= 0x13,
+	association_tag_descriptor			= 0x14,
+	deferred_association_tags_descriptor		= 0x15,
+
+	hierarchical_transmission_descriptor		= 0xc0,
+	digital_copy_control_descriptor			= 0xc1,
+	network_identifier_descriptor			= 0xc2,
+	partial_transport_stream_time_descriptor	= 0xc3,
+	audio_component_descriptor			= 0xc4,
+	hyperlink_descriptor				= 0xc5,
+	target_area_descriptor				= 0xc6,
+	data_contents_descriptor			= 0xc7,
+	video_decode_control_descriptor			= 0xc8,
+	download_content_descriptor			= 0xc9,
+	CA_EMM_TS_descriptor				= 0xca,
+	CA_contract_information_descriptor		= 0xcb,
+	CA_service_descriptor				= 0xcc,
+	TS_Information_descriptior			= 0xcd,
+	extended_broadcaster_descriptor			= 0xce,
+	logo_transmission_descriptor			= 0xcf,
+	basic_local_event_descriptor			= 0xd0,
+	reference_descriptor				= 0xd1,
+	node_relation_descriptor			= 0xd2,
+	short_node_information_descriptor		= 0xd3,
+	STC_reference_descriptor			= 0xd4,
+	series_descriptor				= 0xd5,
+	event_group_descriptor				= 0xd6,
+	SI_parameter_descriptor				= 0xd7,
+	broadcaster_Name_Descriptor			= 0xd8,
+	component_group_descriptor			= 0xd9,
+	SI_prime_TS_descriptor				= 0xda,
+	board_information_descriptor			= 0xdb,
+	LDT_linkage_descriptor				= 0xdc,
+	connected_transmission_descriptor		= 0xdd,
+	content_availability_descriptor			= 0xde,
+	service_group_descriptor			= 0xe0,
+	carousel_compatible_composite_Descriptor	= 0xf7,
+	conditional_playback_descriptor			= 0xf8,
+	ISDBT_delivery_system_descriptor		= 0xfa,
+	partial_reception_descriptor			= 0xfb,
+	emergency_information_descriptor		= 0xfc,
+	data_component_descriptor			= 0xfd,
+	system_management_descriptor			= 0xfe,
+};
+
+
+enum extension_descriptors {
+	image_icon_descriptor				= 0x00,
+	cpcm_delivery_signalling_descriptor		= 0x01,
+	CP_descriptor					= 0x02,
+	CP_identifier_descriptor			= 0x03,
+	T2_delivery_system_descriptor			= 0x04,
+	SH_delivery_system_descriptor			= 0x05,
+	supplementary_audio_descriptor			= 0x06,
+	network_change_notify_descriptor		= 0x07,
+	message_descriptor				= 0x08,
+	target_region_descriptor			= 0x09,
+	target_region_name_descriptor			= 0x0a,
+	service_relocated_descriptor			= 0x0b,
+};
+
+struct pmt_table {
+	uint16_t program_number, pcr_pid;
+	unsigned char version;
+};
+
+struct el_pid {
+	uint8_t  type;
+	uint16_t pid;
+};
+
+struct pid_table {
+	uint16_t service_id;
+	uint16_t pid;
+	struct pmt_table pmt_table;
+	unsigned video_pid_len, audio_pid_len, other_el_pid_len;
+	uint16_t *video_pid;
+	uint16_t *audio_pid;
+	struct el_pid *other_el_pid;
+};
+
+struct pat_table {
+	uint16_t  ts_id;
+	unsigned char version;
+	struct pid_table *pid_table;
+	unsigned pid_table_len;
+};
+
+struct transport_table {
+	uint16_t tr_id;
+};
+
+struct lcn_table {
+	uint16_t service_id;
+	uint16_t lcn;
+};
+
+struct nit_table {
+	uint16_t network_id;
+	unsigned char version;
+	char *network_name, *network_alias;
+	struct transport_table *tr_table;
+	unsigned tr_table_len;
+	unsigned virtual_channel;
+	unsigned area_code;
+
+	/* Network Parameters */
+	uint32_t delivery_system;
+	uint32_t guard_interval;
+	uint32_t fec_inner, fec_outer;
+	uint32_t pol;
+	uint32_t modulation;
+	uint32_t rolloff;
+	uint32_t symbol_rate;
+	uint32_t bandwidth;
+	uint32_t code_rate_hp;
+	uint32_t code_rate_lp;
+	uint32_t transmission_mode;
+	uint32_t hierarchy;
+	uint32_t plp_id;
+	uint32_t system_id;
+
+	unsigned has_dvbt:1;
+	unsigned is_hp:1;
+	unsigned has_time_slicing:1;
+	unsigned has_mpe_fec:1;
+	unsigned has_other_frequency:1;
+	unsigned is_in_depth_interleaver:1;
+
+	char *orbit;
+	uint32_t *frequency;
+	unsigned frequency_len;
+
+	uint32_t *other_frequency;
+	unsigned other_frequency_len;
+
+	uint16_t *partial_reception;
+	unsigned partial_reception_len;
+
+	struct lcn_table *lcn;
+	unsigned lcn_len;
+};
+
+struct service_table {
+	uint16_t service_id;
+	char running;
+	char scrambled;
+	unsigned char type;
+	char *service_name, *service_alias;
+	char *provider_name, *provider_alias;
+};
+
+struct sdt_table {
+	unsigned char version;
+	uint16_t ts_id;
+	struct service_table *service_table;
+	unsigned service_table_len;
+};
+struct dvb_v5_descriptors {
+	int verbose;
+	uint32_t delivery_system;
+
+	struct pat_table pat_table;
+	struct nit_table nit_table;
+	struct sdt_table sdt_table;
+
+	/* Used by descriptors to know where to update a PMT/Service/TS */
+	unsigned cur_pmt;
+	unsigned cur_service;
+	unsigned cur_ts;
+};
+
+void parse_descriptor(enum dvb_tables type,
+		struct dvb_v5_descriptors *dvb_desc,
+		const unsigned char *buf, int len);
+
+int has_descriptor(struct dvb_v5_descriptors *dvb_desc,
+		unsigned char needed_descriptor,
+		const unsigned char *buf, int len);
+
+
+#endif
diff --git a/lib/include/descriptors/desc_cable_delivery.h b/lib/include/descriptors/desc_cable_delivery.h
new file mode 100644
index 0000000..4d10a29
--- /dev/null
+++ b/lib/include/descriptors/desc_cable_delivery.h
@@ -0,0 +1,64 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _CABLE_DELIVERY_H
+#define _CABLE_DELIVERY_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+struct dvb_desc_cable_delivery {
+	uint8_t type;
+	struct dvb_desc *next;
+	uint8_t length;
+
+	uint32_t frequency;
+	union {
+		uint16_t bitfield1;
+		struct {
+			uint16_t fec_outer:4;
+			uint16_t reserved_future_use:12;
+		};
+	};
+	uint8_t modulation;
+	union {
+		uint32_t bitfield2;
+		struct {
+			uint32_t fec_inner:4;
+			uint32_t symbol_rate:28;
+		};
+	};
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+ssize_t dvb_desc_cable_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_cable_delivery_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/desc_frequency_list.h b/lib/include/descriptors/desc_frequency_list.h
new file mode 100644
index 0000000..21f0256
--- /dev/null
+++ b/lib/include/descriptors/desc_frequency_list.h
@@ -0,0 +1,57 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _DESC_FREQUENCY_LIST_H
+#define _DESC_FREQUENCY_LIST_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+struct dvb_desc_frequency_list {
+	uint8_t type;
+	struct dvb_desc *next;
+	uint8_t length;
+
+	union {
+		uint8_t bitfield;
+		struct {
+			uint8_t freq_type:2;
+			uint8_t reserved:6;
+		};
+	};
+	uint8_t frequencies;
+	uint32_t frequency[];
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+ssize_t dvb_desc_frequency_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_frequency_list_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/desc_language.h b/lib/include/descriptors/desc_language.h
new file mode 100644
index 0000000..321a948
--- /dev/null
+++ b/lib/include/descriptors/desc_language.h
@@ -0,0 +1,50 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _LANGUAGE_H
+#define _LANGUAGE_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+struct dvb_desc_language {
+	uint8_t type;
+	struct dvb_desc *next;
+	uint8_t length;
+
+	unsigned char language[4];
+	uint8_t audio_type;
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+ssize_t dvb_desc_language_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_language_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/desc_network_name.h b/lib/include/descriptors/desc_network_name.h
new file mode 100644
index 0000000..011cba9
--- /dev/null
+++ b/lib/include/descriptors/desc_network_name.h
@@ -0,0 +1,49 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _NETWORK_NAME_H
+#define _NETWORK_NAME_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+struct dvb_desc_network_name {
+	uint8_t type;
+	struct dvb_desc *next;
+	uint8_t length;
+
+	unsigned char network_name[];
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+ssize_t dvb_desc_network_name_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_network_name_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/desc_sat.h b/lib/include/descriptors/desc_sat.h
new file mode 100644
index 0000000..a287685
--- /dev/null
+++ b/lib/include/descriptors/desc_sat.h
@@ -0,0 +1,62 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _SAT_H
+#define _SAT_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+struct dvb_desc_sat {
+	uint8_t type;
+	struct dvb_desc *next;
+	uint8_t length;
+
+	uint32_t frequency;
+	uint16_t orbit;
+	uint8_t modulation_type:2;
+	uint8_t modulation_system:1;
+	uint8_t roll_off:2;
+	uint8_t polarization:2;
+	uint8_t west_east:1;
+	union {
+		uint32_t bitfield;
+		struct {
+			uint32_t fec:4;
+			uint32_t symbol_rate:28;
+		};
+	};
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+ssize_t dvb_desc_sat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_sat_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/desc_service.h b/lib/include/descriptors/desc_service.h
new file mode 100644
index 0000000..c5b01cb
--- /dev/null
+++ b/lib/include/descriptors/desc_service.h
@@ -0,0 +1,51 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _DESC_SERVICE_H
+#define _DESC_SERVICE_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+struct dvb_desc_service {
+	uint8_t type;
+	struct dvb_desc *next;
+	uint8_t length;
+
+	uint8_t service_type;
+	char *name;
+	char *provider;
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+ssize_t dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_service_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/desc_service_list.h b/lib/include/descriptors/desc_service_list.h
new file mode 100644
index 0000000..cb60eb5
--- /dev/null
+++ b/lib/include/descriptors/desc_service_list.h
@@ -0,0 +1,54 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _DESC_SERVICE_LIST_H
+#define _DESC_SERVICE_LIST_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+struct dvb_desc_service_list_table {
+	uint16_t service_id;
+	uint8_t service_type;
+} __attribute__((packed));
+
+struct dvb_desc_service_list {
+	uint8_t type;
+	struct dvb_desc *next;
+	uint8_t length;
+
+	struct dvb_desc_service_list_table services[];
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+ssize_t dvb_desc_service_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_service_list_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/desc_terrestrial_delivery.h b/lib/include/descriptors/desc_terrestrial_delivery.h
new file mode 100644
index 0000000..da86cb4
--- /dev/null
+++ b/lib/include/descriptors/desc_terrestrial_delivery.h
@@ -0,0 +1,62 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _TERRESTRIAL_DELIVERY_H
+#define _TERRESTRIAL_DELIVERY_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+struct dvb_desc_terrestrial_delivery {
+	uint8_t type;
+	struct dvb_desc *next;
+	uint8_t length;
+
+	uint32_t centre_frequency;
+	uint8_t reserved_future_use1:2;
+	uint8_t mpe_fec_indicator:1;
+	uint8_t time_slice_indicator:1;
+	uint8_t priority:1;
+	uint8_t bandwidth:3;
+	uint8_t code_rate_hp_stream:3;
+	uint8_t hierarchy_information:3;
+	uint8_t constellation:2;
+	uint8_t other_frequency_flag:1;
+	uint8_t transmission_mode:2;
+	uint8_t guard_interval:2;
+	uint8_t code_rate_lp_stream:3;
+	uint32_t reserved_future_use2;
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+ssize_t dvb_desc_terrestrial_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
+void dvb_desc_terrestrial_delivery_print  (struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/header.h b/lib/include/descriptors/header.h
new file mode 100644
index 0000000..1b9ccf2
--- /dev/null
+++ b/lib/include/descriptors/header.h
@@ -0,0 +1,62 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _HEADER_H
+#define _HEADER_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+struct dvb_table_header {
+	uint8_t  table_id;
+	union {
+		uint16_t bitfield;
+		struct {
+			uint16_t section_length:10;
+			uint8_t  zero:2;
+			uint8_t  one:2;
+			uint8_t  zero2:1;
+			uint8_t  syntax:1;
+		} __attribute__((packed));
+	};
+	uint16_t id;
+	uint8_t  current_next:1;
+	uint8_t  version:5;
+	uint8_t  one2:2;
+
+	uint8_t  section_id;
+	uint8_t  last_section;
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+int  dvb_table_header_init (struct dvb_table_header *t);
+void dvb_table_header_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_header *t);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/nit.h b/lib/include/descriptors/nit.h
new file mode 100644
index 0000000..6a7e472
--- /dev/null
+++ b/lib/include/descriptors/nit.h
@@ -0,0 +1,86 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _NIT_H
+#define _NIT_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+#include "descriptors/header.h"
+#include "descriptors.h"
+
+#define DVB_TABLE_NIT      0x40
+#define DVB_TABLE_NIT_PID  0x10
+
+union dvb_table_nit_transport_header {
+	uint16_t bitfield;
+	struct {
+		uint16_t transport_length:12;
+		uint16_t reserved:4;
+	};
+};
+
+struct dvb_table_nit_transport {
+	uint16_t transport_id;
+	uint16_t network_id;
+	union {
+		uint16_t bitfield;
+		struct {
+			uint16_t section_length:12;
+			uint16_t reserved:4;
+		};
+	};
+	struct dvb_desc *descriptor;
+	struct dvb_table_nit_transport *next;
+} __attribute__((packed));
+
+struct dvb_table_nit {
+	struct dvb_table_header header;
+	union {
+		uint16_t bitfield;
+		struct {
+			uint16_t desc_length:12;
+			uint16_t reserved:4;
+		};
+	};
+	struct dvb_desc *descriptor;
+	struct dvb_table_nit_transport *transport;
+} __attribute__((packed));
+
+
+#define dvb_nit_transport_foreach( tran, nit ) \
+  for( struct dvb_table_nit_transport *tran = nit->transport; tran; tran = tran->next ) \
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+void *dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t size);
+void dvb_table_nit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_nit *nit);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/pat.h b/lib/include/descriptors/pat.h
new file mode 100644
index 0000000..8a7cd60
--- /dev/null
+++ b/lib/include/descriptors/pat.h
@@ -0,0 +1,63 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _PAT_H
+#define _PAT_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+#include "descriptors/header.h"
+
+#define DVB_TABLE_PAT      0
+#define DVB_TABLE_PAT_PID  0
+
+struct dvb_table_pat_program {
+	uint16_t program_id;
+	union {
+		uint16_t bitfield;
+		struct {
+			uint16_t pid:13;
+			uint8_t  reserved:3;
+		} __attribute__((packed));
+	};
+} __attribute__((packed));
+
+struct dvb_table_pat {
+	struct dvb_table_header header;
+	uint16_t programs;
+	struct dvb_table_pat_program program[];
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+void *dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t size);
+void dvb_table_pat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_pat *t);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/pmt.h b/lib/include/descriptors/pmt.h
new file mode 100644
index 0000000..d1cad30
--- /dev/null
+++ b/lib/include/descriptors/pmt.h
@@ -0,0 +1,90 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _PMT_H
+#define _PMT_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+#include "descriptors/header.h"
+
+#define DVB_TABLE_PMT      2
+
+struct dvb_table_pmt_stream {
+	uint8_t type;
+	union {
+		uint16_t bitfield;
+		struct {
+			uint16_t elementary_pid:13;
+			uint16_t  reserved:3;
+		};
+	};
+	union {
+		uint16_t bitfield2;
+		struct {
+			uint16_t section_length:10;
+			uint16_t  zero:2;
+			uint16_t  reserved2:4;
+		};
+	};
+	struct dvb_desc *descriptor;
+	struct dvb_table_pmt_stream *next;
+} __attribute__((packed));
+
+struct dvb_table_pmt {
+	struct dvb_table_header header;
+	union {
+		uint16_t bitfield;
+		struct {
+			uint16_t pcr_pid:13;
+			uint16_t reserved2:3;
+		};
+	};
+
+	union {
+		uint16_t bitfield2;
+		struct {
+			uint16_t prog_length:10;
+			uint16_t  zero3:2;
+			uint16_t  reserved3:4;
+		};
+	};
+	struct dvb_table_pmt_stream *stream;
+} __attribute__((packed));
+
+#define dvb_pmt_stream_foreach(_stream, _pmt) \
+  for( struct dvb_table_pmt_stream *_stream = _pmt->stream; _stream; _stream = _stream->next ) \
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+void *dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t size);
+void dvb_table_pmt_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_pmt *pmt);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/sdt.h b/lib/include/descriptors/sdt.h
new file mode 100644
index 0000000..5cea2d8
--- /dev/null
+++ b/lib/include/descriptors/sdt.h
@@ -0,0 +1,74 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _SDT_H
+#define _SDT_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+#include "descriptors/header.h"
+#include "descriptors.h"
+
+#define DVB_TABLE_SDT      0x42
+#define DVB_TABLE_SDT_PID  0x11
+
+struct dvb_table_sdt_service {
+	uint16_t service_id;
+	uint8_t EIT_present_following:1;
+	uint8_t EIT_schedule:1;
+	uint8_t reserved:6;
+	union {
+		uint16_t bitfield;
+		struct {
+			uint16_t section_length:12;
+			uint16_t free_CA_mode:1;
+			uint16_t running_status:3;
+		} __attribute__((packed));
+	};
+	struct dvb_desc *descriptor;
+	struct dvb_table_sdt_service *next;
+} __attribute__((packed));
+
+struct dvb_table_sdt {
+	struct dvb_table_header header;
+	uint16_t network_id;
+	uint8_t  reserved;
+	struct dvb_table_sdt_service *service;
+} __attribute__((packed));
+
+#define dvb_sdt_service_foreach(_service, _sdt) \
+  for( struct dvb_table_sdt_service *_service = _sdt->service; _service; _service = _service->next ) \
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+void *dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t size);
+void dvb_table_sdt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_sdt *sdt);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/dvb-demux.h b/lib/include/dvb-demux.h
index ec50d6b..240d471 100644
--- a/lib/include/dvb-demux.h
+++ b/lib/include/dvb-demux.h
@@ -29,8 +29,19 @@
 #ifndef _DVB_DEMUX_H
 #define _DVB_DEMUX_H
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+int dvb_dmx_open(int adapter, int demux, unsigned verbose);
+void dvb_dmx_close(int dmx_fd);
+
 int set_pesfilter(int dmxfd, int pid, int pes_type, int dvr);
 
 int get_pmt_pid(const char *dmxdev, int sid);
 
+#ifdef __cplusplus
+}
+#endif
+
 #endif
diff --git a/lib/include/dvb-fe.h b/lib/include/dvb-fe.h
index 939260f..a91a627 100644
--- a/lib/include/dvb-fe.h
+++ b/lib/include/dvb-fe.h
@@ -29,20 +29,9 @@
 #include <fcntl.h>
 #include <sys/ioctl.h>
 #include <string.h>
-#include <syslog.h>
 #include "dvb-frontend.h"
 #include "dvb-sat.h"
-
-#define dvb_log(fmt, arg...) do {\
-	parms->logfunc(LOG_INFO, fmt, ##arg); \
-} while (0)
-#define dvb_logerr(fmt, arg...) do {\
-	parms->logfunc(LOG_ERR, fmt, ##arg); \
-} while (0)
-
-#define dvb_perror(msg) do {\
-	parms->logfunc(LOG_ERR, "%s: %s", msg, strerror(errno)); \
-} while (0)
+#include "dvb-log.h"
 
 #define ARRAY_SIZE(x)	(sizeof(x)/sizeof((x)[0]))
 
@@ -73,7 +62,6 @@ struct dvb_v5_stats {
 	struct dtv_property		prop[DTV_MAX_STATS];
 };
 
-typedef void (*dvb_logfunc)(int level, const char *fmt, ...);
 
 struct dvb_v5_fe_parms {
 	int				fd;
@@ -119,6 +107,9 @@ void dvb_fe_close(struct dvb_v5_fe_parms *parms);
 
 /* Get/set delivery system parameters */
 
+const char *dvb_cmd_name(int cmd);
+const char *const *dvb_attr_names(int cmd);
+
 int dvb_fe_retrieve_parm(const struct dvb_v5_fe_parms *parms,
 			unsigned cmd, uint32_t *value);
 int dvb_fe_store_parm(struct dvb_v5_fe_parms *parms,
@@ -130,8 +121,8 @@ int dvb_add_parms_for_sys(struct dtv_property *dvb_prop,
 			  fe_delivery_system_t sys);
 int dvb_set_compat_delivery_system(struct dvb_v5_fe_parms *parms,
 				   uint32_t desired_system);
-const char *dvb_cmd_name(int cmd);
-void dvb_fe_prt_parms(FILE *fp, const struct dvb_v5_fe_parms *parms);
+
+void dvb_fe_prt_parms(const struct dvb_v5_fe_parms *parms);
 int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms);
 int dvb_fe_get_parms(struct dvb_v5_fe_parms *parms);
 
@@ -193,5 +184,16 @@ extern const unsigned fe_bandwidth_name[8];
 extern const char *dvb_v5_name[61];
 extern const void *dvb_v5_attr_names[];
 extern const char *delivery_system_name[20];
+extern const char *fe_code_rate_name[13];
+extern const char *fe_modulation_name[14];
+extern const char *fe_transmission_mode_name[8];
+extern const unsigned fe_bandwidth_name[8];
+extern const char *fe_guard_interval_name[9];
+extern const char *fe_hierarchy_name[6];
+extern const char *fe_voltage_name[4];
+extern const char *fe_tone_name[3];
+extern const char *fe_inversion_name[4];
+extern const char *fe_pilot_name[4];
+extern const char *fe_rolloff_name[5];
 
 #endif
diff --git a/lib/include/dvb-file.h b/lib/include/dvb-file.h
index 7a605b3..3609c7d 100644
--- a/lib/include/dvb-file.h
+++ b/lib/include/dvb-file.h
@@ -79,7 +79,7 @@ enum file_formats {
 #define PTABLE(a) .table = a, .size=ARRAY_SIZE(a)
 
 
-struct dvb_descriptors;
+struct dvb_v5_descriptors;
 
 #ifdef __cplusplus
 extern "C" {
@@ -130,12 +130,12 @@ struct dvb_file *read_dvb_file(const char *fname);
 
 int write_dvb_file(const char *fname, struct dvb_file *dvb_file);
 
-char *dvb_vchannel(struct dvb_descriptors *dvb_desc,
+char *dvb_vchannel(struct dvb_v5_descriptors *dvb_desc,
 	           int service);
 
 int store_dvb_channel(struct dvb_file **dvb_file,
 		      struct dvb_v5_fe_parms *parms,
-		      struct dvb_descriptors *dvb_desc,
+		      struct dvb_v5_descriptors *dvb_desc,
 		      int get_detected, int get_nit);
 int parse_delsys(const char *name);
 enum file_formats parse_format(const char *name);
diff --git a/lib/include/dvb-log.h b/lib/include/dvb-log.h
new file mode 100644
index 0000000..c085e82
--- /dev/null
+++ b/lib/include/dvb-log.h
@@ -0,0 +1,49 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _LOG_H
+#define _LOG_H
+
+#include <syslog.h>
+
+typedef void (*dvb_logfunc)(int level, const char *fmt, ...) __attribute__ (( format( printf, 2, 3 )));
+
+#define dvb_log(fmt, arg...) do {\
+	parms->logfunc(LOG_INFO, fmt, ##arg); \
+} while (0)
+#define dvb_logerr(fmt, arg...) do {\
+	parms->logfunc(LOG_ERR, fmt, ##arg); \
+} while (0)
+#define dvb_logdbg(fmt, arg...) do {\
+	parms->logfunc(LOG_DEBUG, fmt, ##arg); \
+} while (0)
+#define dvb_logwarn(fmt, arg...) do {\
+	parms->logfunc(LOG_WARNING, fmt, ##arg); \
+} while (0)
+
+
+#define dvb_perror(msg) do {\
+	parms->logfunc(LOG_ERR, "%s: %s", msg, strerror(errno)); \
+} while (0)
+
+void dvb_default_log(int level, const char *fmt, ...) __attribute__ (( format( printf, 2, 3 )));
+
+#endif
diff --git a/lib/include/dvb-scan.h b/lib/include/dvb-scan.h
index a2b061c..284a9b6 100644
--- a/lib/include/dvb-scan.h
+++ b/lib/include/dvb-scan.h
@@ -22,130 +22,24 @@
 #include <stdint.h>
 #include <linux/dvb/dmx.h>
 
-/* According with ISO/IEC 13818-1:2007 */
-
-struct pmt_table {
-	uint16_t program_number, pcr_pid;
-	unsigned char version;
-};
-
-struct el_pid {
-	uint8_t  type;
-	uint16_t pid;
-};
-
-struct pid_table {
-	uint16_t service_id;
-	uint16_t pid;
-	struct pmt_table pmt_table;
-	unsigned video_pid_len, audio_pid_len, other_el_pid_len;
-	uint16_t *video_pid;
-	uint16_t *audio_pid;
-	struct el_pid *other_el_pid;
-};
-
-struct pat_table {
-	uint16_t  ts_id;
-	unsigned char version;
-	struct pid_table *pid_table;
-	unsigned pid_table_len;
-};
-
-struct transport_table {
-	uint16_t tr_id;
-};
-
-struct lcn_table {
-	uint16_t service_id;
-	uint16_t lcn;
-};
-
-struct nit_table {
-	uint16_t network_id;
-	unsigned char version;
-	char *network_name, *network_alias;
-	struct transport_table *tr_table;
-	unsigned tr_table_len;
-	unsigned virtual_channel;
-	unsigned area_code;
-
-	/* Network Parameters */
-	uint32_t delivery_system;
-	uint32_t guard_interval;
-	uint32_t fec_inner, fec_outer;
-	uint32_t pol;
-	uint32_t modulation;
-	uint32_t rolloff;
-	uint32_t symbol_rate;
-	uint32_t bandwidth;
-	uint32_t code_rate_hp;
-	uint32_t code_rate_lp;
-	uint32_t transmission_mode;
-	uint32_t hierarchy;
-	uint32_t plp_id;
-	uint32_t system_id;
-
-	unsigned has_dvbt:1;
-	unsigned is_hp:1;
-	unsigned has_time_slicing:1;
-	unsigned has_mpe_fec:1;
-	unsigned has_other_frequency:1;
-	unsigned is_in_depth_interleaver:1;
+#include "descriptors.h"
 
-	char *orbit;
-	uint32_t *frequency;
-	unsigned frequency_len;
-
-	uint32_t *other_frequency;
-	unsigned other_frequency_len;
-
-	uint16_t *partial_reception;
-	unsigned partial_reception_len;
-
-	struct lcn_table *lcn;
-	unsigned lcn_len;
-};
-
-struct service_table {
-	uint16_t service_id;
-	char running;
-	char scrambled;
-	unsigned char type;
-	char *service_name, *service_alias;
-	char *provider_name, *provider_alias;
-};
-
-struct sdt_table {
-	unsigned char version;
-	uint16_t ts_id;
-	struct service_table *service_table;
-	unsigned service_table_len;
-};
-
-struct dvb_descriptors {
-	int verbose;
-	uint32_t delivery_system;
-
-	struct pat_table pat_table;
-	struct nit_table nit_table;
-	struct sdt_table sdt_table;
+/* According with ISO/IEC 13818-1:2007 */
 
-	/* Used by descriptors to know where to update a PMT/Service/TS */
-	unsigned cur_pmt;
-	unsigned cur_service;
-	unsigned cur_ts;
-};
 
 #ifdef __cplusplus
 extern "C" {
 #endif
 
-struct dvb_descriptors *dvb_get_ts_tables(int dmx_fd,
+int dvb_read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char table, uint16_t pid, unsigned char **buf,
+		unsigned *length, unsigned timeout);
+
+struct dvb_v5_descriptors *dvb_get_ts_tables(int dmx_fd,
 					  uint32_t delivery_system,
 					  unsigned other_nit,
 					  unsigned timeout_multiply,
 					  int verbose);
-void dvb_free_ts_tables(struct dvb_descriptors *dvb_desc);
+void dvb_free_ts_tables(struct dvb_v5_descriptors *dvb_desc);
 
 #ifdef __cplusplus
 }
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index d14cc13..1943ff2 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -11,16 +11,32 @@ endif
 libdvbv5_la_SOURCES = \
   dvb-demux.c ../include/dvb-demux.h \
   dvb-fe.c ../include/dvb-fe.h \
+  dvb-log.c ../include/dvb-log.h \
   dvb-file.c ../include/dvb-file.h \
   ../include/dvb-frontend.h \
   dvb-v5.h dvb-v5.c \
   ../include/dvb-v5-std.h dvb-v5-std.c \
   dvb-legacy-channel-format.c \
   dvb-zap-format.c \
-  descriptors.c descriptors.h \
   dvb-sat.c ../include/dvb-sat.h \
   dvb-scan.c ../include/dvb-scan.h \
-  parse_string.c parse_string.h
+  parse_string.c parse_string.h \
+  crc32.c crc32.h \
+  descriptors.c descriptors.h \
+  descriptors/header.c ../include/descriptors/header.h \
+  descriptors/pat.c  ../include/descriptors/pat.h \
+  descriptors/pmt.c  ../include/descriptors/pmt.h \
+  descriptors/desc_language.c  ../include/descriptors/desc_language.h \
+  descriptors/desc_network_name.c  ../include/descriptors/desc_network_name.h \
+  descriptors/desc_cable_delivery.c  ../include/descriptors/desc_cable_delivery.h \
+  descriptors/desc_sat.c  ../include/descriptors/desc_sat.h \
+  descriptors/desc_terrestrial_delivery.c  ../include/descriptors/desc_terrestrial_delivery.h \
+  descriptors/desc_service.c  ../include/descriptors/desc_service.h \
+  descriptors/desc_frequency_list.c  ../include/descriptors/desc_frequency_list.h \
+  descriptors/desc_service_list.c  ../include/descriptors/desc_service_list.h \
+  descriptors/nit.c  ../include/descriptors/nit.h \
+  descriptors/sdt.c  ../include/descriptors/sdt.h
+
 libdvbv5_la_CPPFLAGS = $(ENFORCE_LIBDVBV5_STATIC)
 libdvbv5_la_LDFLAGS = -version-info 0 $(ENFORCE_LIBDVBV5_STATIC)
 libdvbv5_la_LIBADD = $(LTLIBICONV)
diff --git a/lib/libdvbv5/crc32.c b/lib/libdvbv5/crc32.c
new file mode 100644
index 0000000..37abd78
--- /dev/null
+++ b/lib/libdvbv5/crc32.c
@@ -0,0 +1,76 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "crc32.h"
+
+static uint32_t crctab[256] = {
+  0x00000000, 0x04c11db7, 0x09823b6e, 0x0d4326d9, 0x130476dc, 0x17c56b6b,
+  0x1a864db2, 0x1e475005, 0x2608edb8, 0x22c9f00f, 0x2f8ad6d6, 0x2b4bcb61,
+  0x350c9b64, 0x31cd86d3, 0x3c8ea00a, 0x384fbdbd, 0x4c11db70, 0x48d0c6c7,
+  0x4593e01e, 0x4152fda9, 0x5f15adac, 0x5bd4b01b, 0x569796c2, 0x52568b75,
+  0x6a1936c8, 0x6ed82b7f, 0x639b0da6, 0x675a1011, 0x791d4014, 0x7ddc5da3,
+  0x709f7b7a, 0x745e66cd, 0x9823b6e0, 0x9ce2ab57, 0x91a18d8e, 0x95609039,
+  0x8b27c03c, 0x8fe6dd8b, 0x82a5fb52, 0x8664e6e5, 0xbe2b5b58, 0xbaea46ef,
+  0xb7a96036, 0xb3687d81, 0xad2f2d84, 0xa9ee3033, 0xa4ad16ea, 0xa06c0b5d,
+  0xd4326d90, 0xd0f37027, 0xddb056fe, 0xd9714b49, 0xc7361b4c, 0xc3f706fb,
+  0xceb42022, 0xca753d95, 0xf23a8028, 0xf6fb9d9f, 0xfbb8bb46, 0xff79a6f1,
+  0xe13ef6f4, 0xe5ffeb43, 0xe8bccd9a, 0xec7dd02d, 0x34867077, 0x30476dc0,
+  0x3d044b19, 0x39c556ae, 0x278206ab, 0x23431b1c, 0x2e003dc5, 0x2ac12072,
+  0x128e9dcf, 0x164f8078, 0x1b0ca6a1, 0x1fcdbb16, 0x018aeb13, 0x054bf6a4,
+  0x0808d07d, 0x0cc9cdca, 0x7897ab07, 0x7c56b6b0, 0x71159069, 0x75d48dde,
+  0x6b93dddb, 0x6f52c06c, 0x6211e6b5, 0x66d0fb02, 0x5e9f46bf, 0x5a5e5b08,
+  0x571d7dd1, 0x53dc6066, 0x4d9b3063, 0x495a2dd4, 0x44190b0d, 0x40d816ba,
+  0xaca5c697, 0xa864db20, 0xa527fdf9, 0xa1e6e04e, 0xbfa1b04b, 0xbb60adfc,
+  0xb6238b25, 0xb2e29692, 0x8aad2b2f, 0x8e6c3698, 0x832f1041, 0x87ee0df6,
+  0x99a95df3, 0x9d684044, 0x902b669d, 0x94ea7b2a, 0xe0b41de7, 0xe4750050,
+  0xe9362689, 0xedf73b3e, 0xf3b06b3b, 0xf771768c, 0xfa325055, 0xfef34de2,
+  0xc6bcf05f, 0xc27dede8, 0xcf3ecb31, 0xcbffd686, 0xd5b88683, 0xd1799b34,
+  0xdc3abded, 0xd8fba05a, 0x690ce0ee, 0x6dcdfd59, 0x608edb80, 0x644fc637,
+  0x7a089632, 0x7ec98b85, 0x738aad5c, 0x774bb0eb, 0x4f040d56, 0x4bc510e1,
+  0x46863638, 0x42472b8f, 0x5c007b8a, 0x58c1663d, 0x558240e4, 0x51435d53,
+  0x251d3b9e, 0x21dc2629, 0x2c9f00f0, 0x285e1d47, 0x36194d42, 0x32d850f5,
+  0x3f9b762c, 0x3b5a6b9b, 0x0315d626, 0x07d4cb91, 0x0a97ed48, 0x0e56f0ff,
+  0x1011a0fa, 0x14d0bd4d, 0x19939b94, 0x1d528623, 0xf12f560e, 0xf5ee4bb9,
+  0xf8ad6d60, 0xfc6c70d7, 0xe22b20d2, 0xe6ea3d65, 0xeba91bbc, 0xef68060b,
+  0xd727bbb6, 0xd3e6a601, 0xdea580d8, 0xda649d6f, 0xc423cd6a, 0xc0e2d0dd,
+  0xcda1f604, 0xc960ebb3, 0xbd3e8d7e, 0xb9ff90c9, 0xb4bcb610, 0xb07daba7,
+  0xae3afba2, 0xaafbe615, 0xa7b8c0cc, 0xa379dd7b, 0x9b3660c6, 0x9ff77d71,
+  0x92b45ba8, 0x9675461f, 0x8832161a, 0x8cf30bad, 0x81b02d74, 0x857130c3,
+  0x5d8a9099, 0x594b8d2e, 0x5408abf7, 0x50c9b640, 0x4e8ee645, 0x4a4ffbf2,
+  0x470cdd2b, 0x43cdc09c, 0x7b827d21, 0x7f436096, 0x7200464f, 0x76c15bf8,
+  0x68860bfd, 0x6c47164a, 0x61043093, 0x65c52d24, 0x119b4be9, 0x155a565e,
+  0x18197087, 0x1cd86d30, 0x029f3d35, 0x065e2082, 0x0b1d065b, 0x0fdc1bec,
+  0x3793a651, 0x3352bbe6, 0x3e119d3f, 0x3ad08088, 0x2497d08d, 0x2056cd3a,
+  0x2d15ebe3, 0x29d4f654, 0xc5a92679, 0xc1683bce, 0xcc2b1d17, 0xc8ea00a0,
+  0xd6ad50a5, 0xd26c4d12, 0xdf2f6bcb, 0xdbee767c, 0xe3a1cbc1, 0xe760d676,
+  0xea23f0af, 0xeee2ed18, 0xf0a5bd1d, 0xf464a0aa, 0xf9278673, 0xfde69bc4,
+  0x89b8fd09, 0x8d79e0be, 0x803ac667, 0x84fbdbd0, 0x9abc8bd5, 0x9e7d9662,
+  0x933eb0bb, 0x97ffad0c, 0xafb010b1, 0xab710d06, 0xa6322bdf, 0xa2f33668,
+  0xbcb4666d, 0xb8757bda, 0xb5365d03, 0xb1f740b4
+};
+
+inline uint32_t crc32(uint8_t *data, size_t len, uint32_t crc)
+{
+  while(len--)
+    crc = (crc << 8) ^ crctab[((crc >> 24) ^ *data++) & 0xff];
+  return crc;
+}
+
diff --git a/lib/libdvbv5/crc32.h b/lib/libdvbv5/crc32.h
new file mode 100644
index 0000000..69af116
--- /dev/null
+++ b/lib/libdvbv5/crc32.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _CRC32_H
+#define _CRC32_H
+
+#include <stdint.h>
+#include <unistd.h> /* size_t */
+
+uint32_t crc32(uint8_t *data, size_t datalen, uint32_t crc);
+
+#endif
+
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 63c4b56..288fc58 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -22,12 +22,41 @@
 #include <stdlib.h>
 #include <stdio.h>
 
+#include "descriptors.h"
 #include "dvb-fe.h"
 #include "dvb-scan.h"
-#include "descriptors.h"
 #include "parse_string.h"
 #include "dvb-frontend.h"
 #include "dvb-v5-std.h"
+#include "dvb-log.h"
+
+#include "descriptors/pat.h"
+#include "descriptors/pmt.h"
+#include "descriptors/desc_language.h"
+#include "descriptors/desc_network_name.h"
+#include "descriptors/desc_cable_delivery.h"
+#include "descriptors/desc_sat.h"
+#include "descriptors/desc_terrestrial_delivery.h"
+#include "descriptors/desc_service.h"
+#include "descriptors/desc_service_list.h"
+#include "descriptors/desc_frequency_list.h"
+#include "descriptors/nit.h"
+#include "descriptors/sdt.h"
+
+ssize_t dvb_desc_init(const uint8_t *buf, struct dvb_desc *desc)
+{
+	desc->type   = buf[0];
+	desc->next   = NULL;
+	desc->length = buf[1];
+	return 2;
+}
+
+const struct dvb_table_init dvb_table_initializers[] = {
+	[DVB_TABLE_PAT] = { dvb_table_pat_init },
+	[DVB_TABLE_PMT] = { dvb_table_pmt_init },
+	[DVB_TABLE_NIT] = { dvb_table_nit_init },
+	[DVB_TABLE_SDT] = { dvb_table_sdt_init },
+};
 
 static char *default_charset = "iso-8859-1";
 static char *output_charset = "utf-8";
@@ -39,156 +68,182 @@ static char *table[] = {
 	[SDT] = "SDT",
 };
 
-static const char *descriptors[] = {
-	[0 ...255 ] = "Unknown descriptor",
-	[video_stream_descriptor] = "video_stream_descriptor",
-	[audio_stream_descriptor] = "audio_stream_descriptor",
-	[hierarchy_descriptor] = "hierarchy_descriptor",
-	[dvbpsi_registration_descriptor] = "dvbpsi_registration_descriptor",
-	[ds_alignment_descriptor] = "ds_alignment_descriptor",
-	[target_background_grid_descriptor] = "target_background_grid_descriptor",
-	[video_window_descriptor] = "video_window_descriptor",
-	[conditional_access_descriptor] = "conditional_access_descriptor",
-	[iso639_language_descriptor] = "iso639_language_descriptor",
-	[system_clock_descriptor] = "system_clock_descriptor",
-	[multiplex_buffer_utilization_descriptor] = "multiplex_buffer_utilization_descriptor",
-	[copyright_descriptor] = "copyright_descriptor",
-	[maximum_bitrate_descriptor] = "maximum_bitrate_descriptor",
-	[private_data_indicator_descriptor] = "private_data_indicator_descriptor",
-	[smoothing_buffer_descriptor] = "smoothing_buffer_descriptor",
-	[std_descriptor] = "std_descriptor",
-	[ibp_descriptor] = "ibp_descriptor",
-	[mpeg4_video_descriptor] = "mpeg4_video_descriptor",
-	[mpeg4_audio_descriptor] = "mpeg4_audio_descriptor",
-	[iod_descriptor] = "iod_descriptor",
-	[sl_descriptor] = "sl_descriptor",
-	[fmc_descriptor] = "fmc_descriptor",
-	[external_es_id_descriptor] = "external_es_id_descriptor",
-	[muxcode_descriptor] = "muxcode_descriptor",
-	[fmxbuffersize_descriptor] = "fmxbuffersize_descriptor",
-	[multiplexbuffer_descriptor] = "multiplexbuffer_descriptor",
-	[content_labeling_descriptor] = "content_labeling_descriptor",
-	[metadata_pointer_descriptor] = "metadata_pointer_descriptor",
-	[metadata_descriptor] = "metadata_descriptor",
-	[metadata_std_descriptor] = "metadata_std_descriptor",
-	[AVC_video_descriptor] = "AVC_video_descriptor",
-	[ipmp_descriptor] = "ipmp_descriptor",
-	[AVC_timing_and_HRD_descriptor] = "AVC_timing_and_HRD_descriptor",
-	[mpeg2_aac_audio_descriptor] = "mpeg2_aac_audio_descriptor",
-	[flexmux_timing_descriptor] = "flexmux_timing_descriptor",
-	[network_name_descriptor] = "network_name_descriptor",
-	[service_list_descriptor] = "service_list_descriptor",
-	[stuffing_descriptor] = "stuffing_descriptor",
-	[satellite_delivery_system_descriptor] = "satellite_delivery_system_descriptor",
-	[cable_delivery_system_descriptor] = "cable_delivery_system_descriptor",
-	[VBI_data_descriptor] = "VBI_data_descriptor",
-	[VBI_teletext_descriptor] = "VBI_teletext_descriptor",
-	[bouquet_name_descriptor] = "bouquet_name_descriptor",
-	[service_descriptor] = "service_descriptor",
-	[country_availability_descriptor] = "country_availability_descriptor",
-	[linkage_descriptor] = "linkage_descriptor",
-	[NVOD_reference_descriptor] = "NVOD_reference_descriptor",
-	[time_shifted_service_descriptor] = "time_shifted_service_descriptor",
-	[short_event_descriptor] = "short_event_descriptor",
-	[extended_event_descriptor] = "extended_event_descriptor",
-	[time_shifted_event_descriptor] = "time_shifted_event_descriptor",
-	[component_descriptor] = "component_descriptor",
-	[mosaic_descriptor] = "mosaic_descriptor",
-	[stream_identifier_descriptor] = "stream_identifier_descriptor",
-	[CA_identifier_descriptor] = "CA_identifier_descriptor",
-	[content_descriptor] = "content_descriptor",
-	[parental_rating_descriptor] = "parental_rating_descriptor",
-	[teletext_descriptor] = "teletext_descriptor",
-	[telephone_descriptor] = "telephone_descriptor",
-	[local_time_offset_descriptor] = "local_time_offset_descriptor",
-	[subtitling_descriptor] = "subtitling_descriptor",
-	[terrestrial_delivery_system_descriptor] = "terrestrial_delivery_system_descriptor",
-	[multilingual_network_name_descriptor] = "multilingual_network_name_descriptor",
-	[multilingual_bouquet_name_descriptor] = "multilingual_bouquet_name_descriptor",
-	[multilingual_service_name_descriptor] = "multilingual_service_name_descriptor",
-	[multilingual_component_descriptor] = "multilingual_component_descriptor",
-	[private_data_specifier_descriptor] = "private_data_specifier_descriptor",
-	[service_move_descriptor] = "service_move_descriptor",
-	[short_smoothing_buffer_descriptor] = "short_smoothing_buffer_descriptor",
-	[frequency_list_descriptor] = "frequency_list_descriptor",
-	[partial_transport_stream_descriptor] = "partial_transport_stream_descriptor",
-	[data_broadcast_descriptor] = "data_broadcast_descriptor",
-	[scrambling_descriptor] = "scrambling_descriptor",
-	[data_broadcast_id_descriptor] = "data_broadcast_id_descriptor",
-	[transport_stream_descriptor] = "transport_stream_descriptor",
-	[DSNG_descriptor] = "DSNG_descriptor",
-	[PDC_descriptor] = "PDC_descriptor",
-	[AC_3_descriptor] = "AC_3_descriptor",
-	[ancillary_data_descriptor] = "ancillary_data_descriptor",
-	[cell_list_descriptor] = "cell_list_descriptor",
-	[cell_frequency_link_descriptor] = "cell_frequency_link_descriptor",
-	[announcement_support_descriptor] = "announcement_support_descriptor",
-	[application_signalling_descriptor] = "application_signalling_descriptor",
-	[adaptation_field_data_descriptor] = "adaptation_field_data_descriptor",
-	[service_identifier_descriptor] = "service_identifier_descriptor",
-	[service_availability_descriptor] = "service_availability_descriptor",
-	[default_authority_descriptor] = "default_authority_descriptor",
-	[related_content_descriptor] = "related_content_descriptor",
-	[TVA_id_descriptor] = "TVA_id_descriptor",
-	[content_identifier_descriptor] = "content_identifier_descriptor",
-	[time_slice_fec_identifier_descriptor] = "time_slice_fec_identifier_descriptor",
-	[ECM_repetition_rate_descriptor] = "ECM_repetition_rate_descriptor",
-	[S2_satellite_delivery_system_descriptor] = "S2_satellite_delivery_system_descriptor",
-	[enhanced_AC_3_descriptor] = "enhanced_AC_3_descriptor",
-	[DTS_descriptor] = "DTS_descriptor",
-	[AAC_descriptor] = "AAC_descriptor",
-	[XAIT_location_descriptor] = "XAIT_location_descriptor",
-	[FTA_content_management_descriptor] = "FTA_content_management_descriptor",
-	[extension_descriptor] = "extension_descriptor",
-
-	[CUE_identifier_descriptor] = "CUE_identifier_descriptor",
-
-	[component_name_descriptor] = "component_name_descriptor",
-	[logical_channel_number_descriptor] = "logical_channel_number_descriptor",
-
-	[carousel_id_descriptor] = "carousel_id_descriptor",
-	[association_tag_descriptor] = "association_tag_descriptor",
-	[deferred_association_tags_descriptor] = "deferred_association_tags_descriptor",
-
-	[hierarchical_transmission_descriptor] = "hierarchical_transmission_descriptor",
-	[digital_copy_control_descriptor] = "digital_copy_control_descriptor",
-	[network_identifier_descriptor] = "network_identifier_descriptor",
-	[partial_transport_stream_time_descriptor] = "partial_transport_stream_time_descriptor",
-	[audio_component_descriptor] = "audio_component_descriptor",
-	[hyperlink_descriptor] = "hyperlink_descriptor",
-	[target_area_descriptor] = "target_area_descriptor",
-	[data_contents_descriptor] = "data_contents_descriptor",
-	[video_decode_control_descriptor] = "video_decode_control_descriptor",
-	[download_content_descriptor] = "download_content_descriptor",
-	[CA_EMM_TS_descriptor] = "CA_EMM_TS_descriptor",
-	[CA_contract_information_descriptor] = "CA_contract_information_descriptor",
-	[CA_service_descriptor] = "CA_service_descriptor",
-	[TS_Information_descriptior] = "TS_Information_descriptior",
-	[extended_broadcaster_descriptor] = "extended_broadcaster_descriptor",
-	[logo_transmission_descriptor] = "logo_transmission_descriptor",
-	[basic_local_event_descriptor] = "basic_local_event_descriptor",
-	[reference_descriptor] = "reference_descriptor",
-	[node_relation_descriptor] = "node_relation_descriptor",
-	[short_node_information_descriptor] = "short_node_information_descriptor",
-	[STC_reference_descriptor] = "STC_reference_descriptor",
-	[series_descriptor] = "series_descriptor",
-	[event_group_descriptor] = "event_group_descriptor",
-	[SI_parameter_descriptor] = "SI_parameter_descriptor",
-	[broadcaster_Name_Descriptor] = "broadcaster_Name_Descriptor",
-	[component_group_descriptor] = "component_group_descriptor",
-	[SI_prime_TS_descriptor] = "SI_prime_TS_descriptor",
-	[board_information_descriptor] = "board_information_descriptor",
-	[LDT_linkage_descriptor] = "LDT_linkage_descriptor",
-	[connected_transmission_descriptor] = "connected_transmission_descriptor",
-	[content_availability_descriptor] = "content_availability_descriptor",
-	[service_group_descriptor] = "service_group_descriptor",
-	[carousel_compatible_composite_Descriptor] = "carousel_compatible_composite_Descriptor",
-	[conditional_playback_descriptor] = "conditional_playback_descriptor",
-	[ISDBT_delivery_system_descriptor] = "ISDBT_delivery_system_descriptor",
-	[partial_reception_descriptor] = "partial_reception_descriptor",
-	[emergency_information_descriptor] = "emergency_information_descriptor",
-	[data_component_descriptor] = "data_component_descriptor",
-	[system_management_descriptor] = "system_management_descriptor",
+ssize_t dvb_parse_descriptors(struct dvb_v5_fe_parms *parms, const uint8_t *buf, uint8_t *dest, uint16_t section_length, struct dvb_desc **head_desc)
+{
+	const uint8_t *ptr = buf;
+	ssize_t length = 0;
+	struct dvb_desc *current = NULL;
+	struct dvb_desc *last = NULL;
+	while (ptr < buf + section_length) {
+	    current = (struct dvb_desc *) dest;
+	    ptr += dvb_desc_init(ptr, current); /* the standard header was read */
+		if (dvb_descriptors[current->type].init) {
+			ssize_t len = dvb_descriptors[current->type].init(parms, ptr, current);
+			if(!*head_desc)
+				*head_desc = current;
+			if (last)
+				last->next = current;
+			last = current;
+			dest += len;
+			length += len;
+		} else {
+			dvb_logdbg("no parser for descriptor %s (%d)", dvb_descriptors[current->type].name, current->type);
+		}
+		ptr += current->length;     /* standard descriptor header plus descriptor length */
+	}
+	return length;
+}
+
+const struct dvb_descriptor dvb_descriptors[] = {
+	[0 ...255 ] = { "Unknown descriptor", NULL, NULL },
+	[video_stream_descriptor] = { "video_stream_descriptor", NULL, NULL },
+	[audio_stream_descriptor] = { "audio_stream_descriptor", NULL, NULL },
+	[hierarchy_descriptor] = { "hierarchy_descriptor", NULL, NULL },
+	[dvbpsi_registration_descriptor] = { "dvbpsi_registration_descriptor", NULL, NULL },
+	[ds_alignment_descriptor] = { "ds_alignment_descriptor", NULL, NULL },
+	[target_background_grid_descriptor] = { "target_background_grid_descriptor", NULL, NULL },
+	[video_window_descriptor] = { "video_window_descriptor", NULL, NULL },
+	[conditional_access_descriptor] = { "conditional_access_descriptor", NULL, NULL },
+	[iso639_language_descriptor] = { "iso639_language_descriptor", dvb_desc_language_init, dvb_desc_language_print },
+	[system_clock_descriptor] = { "system_clock_descriptor", NULL, NULL },
+	[multiplex_buffer_utilization_descriptor] = { "multiplex_buffer_utilization_descriptor", NULL, NULL },
+	[copyright_descriptor] = { "copyright_descriptor", NULL, NULL },
+	[maximum_bitrate_descriptor] = { "maximum_bitrate_descriptor", NULL, NULL },
+	[private_data_indicator_descriptor] = { "private_data_indicator_descriptor", NULL, NULL },
+	[smoothing_buffer_descriptor] = { "smoothing_buffer_descriptor", NULL, NULL },
+	[std_descriptor] = { "std_descriptor", NULL, NULL },
+	[ibp_descriptor] = { "ibp_descriptor", NULL, NULL },
+	[mpeg4_video_descriptor] = { "mpeg4_video_descriptor", NULL, NULL },
+	[mpeg4_audio_descriptor] = { "mpeg4_audio_descriptor", NULL, NULL },
+	[iod_descriptor] = { "iod_descriptor", NULL, NULL },
+	[sl_descriptor] = { "sl_descriptor", NULL, NULL },
+	[fmc_descriptor] = { "fmc_descriptor", NULL, NULL },
+	[external_es_id_descriptor] = { "external_es_id_descriptor", NULL, NULL },
+	[muxcode_descriptor] = { "muxcode_descriptor", NULL, NULL },
+	[fmxbuffersize_descriptor] = { "fmxbuffersize_descriptor", NULL, NULL },
+	[multiplexbuffer_descriptor] = { "multiplexbuffer_descriptor", NULL, NULL },
+	[content_labeling_descriptor] = { "content_labeling_descriptor", NULL, NULL },
+	[metadata_pointer_descriptor] = { "metadata_pointer_descriptor", NULL, NULL },
+	[metadata_descriptor] = { "metadata_descriptor", NULL, NULL },
+	[metadata_std_descriptor] = { "metadata_std_descriptor", NULL, NULL },
+	[AVC_video_descriptor] = { "AVC_video_descriptor", NULL, NULL },
+	[ipmp_descriptor] = { "ipmp_descriptor", NULL, NULL },
+	[AVC_timing_and_HRD_descriptor] = { "AVC_timing_and_HRD_descriptor", NULL, NULL },
+	[mpeg2_aac_audio_descriptor] = { "mpeg2_aac_audio_descriptor", NULL, NULL },
+	[flexmux_timing_descriptor] = { "flexmux_timing_descriptor", NULL, NULL },
+	[network_name_descriptor] = { "network_name_descriptor", dvb_desc_network_name_init, dvb_desc_network_name_print },
+	[service_list_descriptor] = { "service_list_descriptor", dvb_desc_service_list_init, dvb_desc_service_list_print },
+	[stuffing_descriptor] = { "stuffing_descriptor", NULL, NULL },
+	[satellite_delivery_system_descriptor] = { "satellite_delivery_system_descriptor", dvb_desc_sat_init, dvb_desc_sat_print },
+	[cable_delivery_system_descriptor] = { "cable_delivery_system_descriptor", dvb_desc_cable_delivery_init, dvb_desc_cable_delivery_print },
+	[VBI_data_descriptor] = { "VBI_data_descriptor", NULL, NULL },
+	[VBI_teletext_descriptor] = { "VBI_teletext_descriptor", NULL, NULL },
+	[bouquet_name_descriptor] = { "bouquet_name_descriptor", NULL, NULL },
+	[service_descriptor] = { "service_descriptor", dvb_desc_service_init, dvb_desc_service_print },
+	[country_availability_descriptor] = { "country_availability_descriptor", NULL, NULL },
+	[linkage_descriptor] = { "linkage_descriptor", NULL, NULL },
+	[NVOD_reference_descriptor] = { "NVOD_reference_descriptor", NULL, NULL },
+	[time_shifted_service_descriptor] = { "time_shifted_service_descriptor", NULL, NULL },
+	[short_event_descriptor] = { "short_event_descriptor", NULL, NULL },
+	[extended_event_descriptor] = { "extended_event_descriptor", NULL, NULL },
+	[time_shifted_event_descriptor] = { "time_shifted_event_descriptor", NULL, NULL },
+	[component_descriptor] = { "component_descriptor", NULL, NULL },
+	[mosaic_descriptor] = { "mosaic_descriptor", NULL, NULL },
+	[stream_identifier_descriptor] = { "stream_identifier_descriptor", NULL, NULL },
+	[CA_identifier_descriptor] = { "CA_identifier_descriptor", NULL, NULL },
+	[content_descriptor] = { "content_descriptor", NULL, NULL },
+	[parental_rating_descriptor] = { "parental_rating_descriptor", NULL, NULL },
+	[teletext_descriptor] = { "teletext_descriptor", NULL, NULL },
+	[telephone_descriptor] = { "telephone_descriptor", NULL, NULL },
+	[local_time_offset_descriptor] = { "local_time_offset_descriptor", NULL, NULL },
+	[subtitling_descriptor] = { "subtitling_descriptor", NULL, NULL },
+	[terrestrial_delivery_system_descriptor] = { "terrestrial_delivery_system_descriptor", dvb_desc_terrestrial_delivery_init, dvb_desc_terrestrial_delivery_print },
+	[multilingual_network_name_descriptor] = { "multilingual_network_name_descriptor", NULL, NULL },
+	[multilingual_bouquet_name_descriptor] = { "multilingual_bouquet_name_descriptor", NULL, NULL },
+	[multilingual_service_name_descriptor] = { "multilingual_service_name_descriptor", NULL, NULL },
+	[multilingual_component_descriptor] = { "multilingual_component_descriptor", NULL, NULL },
+	[private_data_specifier_descriptor] = { "private_data_specifier_descriptor", NULL, NULL },
+	[service_move_descriptor] = { "service_move_descriptor", NULL, NULL },
+	[short_smoothing_buffer_descriptor] = { "short_smoothing_buffer_descriptor", NULL, NULL },
+	[frequency_list_descriptor] = { "frequency_list_descriptor", dvb_desc_frequency_list_init, dvb_desc_frequency_list_print },
+	[partial_transport_stream_descriptor] = { "partial_transport_stream_descriptor", NULL, NULL },
+	[data_broadcast_descriptor] = { "data_broadcast_descriptor", NULL, NULL },
+	[scrambling_descriptor] = { "scrambling_descriptor", NULL, NULL },
+	[data_broadcast_id_descriptor] = { "data_broadcast_id_descriptor", NULL, NULL },
+	[transport_stream_descriptor] = { "transport_stream_descriptor", NULL, NULL },
+	[DSNG_descriptor] = { "DSNG_descriptor", NULL, NULL },
+	[PDC_descriptor] = { "PDC_descriptor", NULL, NULL },
+	[AC_3_descriptor] = { "AC_3_descriptor", NULL, NULL },
+	[ancillary_data_descriptor] = { "ancillary_data_descriptor", NULL, NULL },
+	[cell_list_descriptor] = { "cell_list_descriptor", NULL, NULL },
+	[cell_frequency_link_descriptor] = { "cell_frequency_link_descriptor", NULL, NULL },
+	[announcement_support_descriptor] = { "announcement_support_descriptor", NULL, NULL },
+	[application_signalling_descriptor] = { "application_signalling_descriptor", NULL, NULL },
+	[adaptation_field_data_descriptor] = { "adaptation_field_data_descriptor", NULL, NULL },
+	[service_identifier_descriptor] = { "service_identifier_descriptor", NULL, NULL },
+	[service_availability_descriptor] = { "service_availability_descriptor", NULL, NULL },
+	[default_authority_descriptor] = { "default_authority_descriptor", NULL, NULL },
+	[related_content_descriptor] = { "related_content_descriptor", NULL, NULL },
+	[TVA_id_descriptor] = { "TVA_id_descriptor", NULL, NULL },
+	[content_identifier_descriptor] = { "content_identifier_descriptor", NULL, NULL },
+	[time_slice_fec_identifier_descriptor] = { "time_slice_fec_identifier_descriptor", NULL, NULL },
+	[ECM_repetition_rate_descriptor] = { "ECM_repetition_rate_descriptor", NULL, NULL },
+	[S2_satellite_delivery_system_descriptor] = { "S2_satellite_delivery_system_descriptor", NULL, NULL },
+	[enhanced_AC_3_descriptor] = { "enhanced_AC_3_descriptor", NULL, NULL },
+	[DTS_descriptor] = { "DTS_descriptor", NULL, NULL },
+	[AAC_descriptor] = { "AAC_descriptor", NULL, NULL },
+	[XAIT_location_descriptor] = { "XAIT_location_descriptor", NULL, NULL },
+	[FTA_content_management_descriptor] = { "FTA_content_management_descriptor", NULL, NULL },
+	[extension_descriptor] = { "extension_descriptor", NULL, NULL },
+
+	[CUE_identifier_descriptor] = { "CUE_identifier_descriptor", NULL, NULL },
+
+	[component_name_descriptor] = { "component_name_descriptor", NULL, NULL },
+	[logical_channel_number_descriptor] = { "logical_channel_number_descriptor", NULL, NULL },
+
+	[carousel_id_descriptor] = { "carousel_id_descriptor", NULL, NULL },
+	[association_tag_descriptor] = { "association_tag_descriptor", NULL, NULL },
+	[deferred_association_tags_descriptor] = { "deferred_association_tags_descriptor", NULL, NULL },
+
+	[hierarchical_transmission_descriptor] = { "hierarchical_transmission_descriptor", NULL, NULL },
+	[digital_copy_control_descriptor] = { "digital_copy_control_descriptor", NULL, NULL },
+	[network_identifier_descriptor] = { "network_identifier_descriptor", NULL, NULL },
+	[partial_transport_stream_time_descriptor] = { "partial_transport_stream_time_descriptor", NULL, NULL },
+	[audio_component_descriptor] = { "audio_component_descriptor", NULL, NULL },
+	[hyperlink_descriptor] = { "hyperlink_descriptor", NULL, NULL },
+	[target_area_descriptor] = { "target_area_descriptor", NULL, NULL },
+	[data_contents_descriptor] = { "data_contents_descriptor", NULL, NULL },
+	[video_decode_control_descriptor] = { "video_decode_control_descriptor", NULL, NULL },
+	[download_content_descriptor] = { "download_content_descriptor", NULL, NULL },
+	[CA_EMM_TS_descriptor] = { "CA_EMM_TS_descriptor", NULL, NULL },
+	[CA_contract_information_descriptor] = { "CA_contract_information_descriptor", NULL, NULL },
+	[CA_service_descriptor] = { "CA_service_descriptor", NULL, NULL },
+	[TS_Information_descriptior] = { "TS_Information_descriptior", NULL, NULL },
+	[extended_broadcaster_descriptor] = { "extended_broadcaster_descriptor", NULL, NULL },
+	[logo_transmission_descriptor] = { "logo_transmission_descriptor", NULL, NULL },
+	[basic_local_event_descriptor] = { "basic_local_event_descriptor", NULL, NULL },
+	[reference_descriptor] = { "reference_descriptor", NULL, NULL },
+	[node_relation_descriptor] = { "node_relation_descriptor", NULL, NULL },
+	[short_node_information_descriptor] = { "short_node_information_descriptor", NULL, NULL },
+	[STC_reference_descriptor] = { "STC_reference_descriptor", NULL, NULL },
+	[series_descriptor] = { "series_descriptor", NULL, NULL },
+	[event_group_descriptor] = { "event_group_descriptor", NULL, NULL },
+	[SI_parameter_descriptor] = { "SI_parameter_descriptor", NULL, NULL },
+	[broadcaster_Name_Descriptor] = { "broadcaster_Name_Descriptor", NULL, NULL },
+	[component_group_descriptor] = { "component_group_descriptor", NULL, NULL },
+	[SI_prime_TS_descriptor] = { "SI_prime_TS_descriptor", NULL, NULL },
+	[board_information_descriptor] = { "board_information_descriptor", NULL, NULL },
+	[LDT_linkage_descriptor] = { "LDT_linkage_descriptor", NULL, NULL },
+	[connected_transmission_descriptor] = { "connected_transmission_descriptor", NULL, NULL },
+	[content_availability_descriptor] = { "content_availability_descriptor", NULL, NULL },
+	[service_group_descriptor] = { "service_group_descriptor", NULL, NULL },
+	[carousel_compatible_composite_Descriptor] = { "carousel_compatible_composite_Descriptor", NULL, NULL },
+	[conditional_playback_descriptor] = { "conditional_playback_descriptor", NULL, NULL },
+	[ISDBT_delivery_system_descriptor] = { "ISDBT_delivery_system_descriptor", NULL, NULL },
+	[partial_reception_descriptor] = { "partial_reception_descriptor", NULL, NULL },
+	[emergency_information_descriptor] = { "emergency_information_descriptor", NULL, NULL },
+	[data_component_descriptor] = { "data_component_descriptor", NULL, NULL },
+	[system_management_descriptor] = { "system_management_descriptor", NULL, NULL },
 };
 
 static const char *extension_descriptors[] = {
@@ -207,7 +262,18 @@ static const char *extension_descriptors[] = {
 };
 
 
-static int bcd_to_int(const unsigned char *bcd, int bits)
+uint32_t bcd(uint32_t bcd)
+{
+	uint32_t ret = 0, mult = 1;
+	while (bcd) {
+		ret += (bcd & 0x0f) * mult;
+		bcd >>=4;
+		mult *= 10;
+	}
+	return ret;
+}
+
+int bcd_to_int(const unsigned char *bcd, int bits)
 {
 	int nibble = 0;
 	int ret = 0;
@@ -231,7 +297,7 @@ static int add_frequency(struct nit_table *nit_table, uint32_t freq)
 	unsigned n = nit_table->frequency_len;
 
 	nit_table->frequency = realloc(nit_table->frequency,
-				       (n + 1) * sizeof(*nit_table->frequency));
+			(n + 1) * sizeof(*nit_table->frequency));
 
 	if (!nit_table->frequency)
 		return -ENOMEM;
@@ -243,8 +309,8 @@ static int add_frequency(struct nit_table *nit_table, uint32_t freq)
 }
 
 static void parse_NIT_ISDBT(struct nit_table *nit_table,
-			     const unsigned char *buf, int dlen,
-			     int verbose)
+		const unsigned char *buf, int dlen,
+		int verbose)
 {
 	uint64_t freq;
 	static const uint32_t interval[] = {
@@ -282,10 +348,10 @@ static void parse_NIT_ISDBT(struct nit_table *nit_table,
 	nit_table->transmission_mode = mode[isdbt_mode];
 	if (verbose)
 		printf("Area code: %d, mode %d (%s), guard interval: %s\n",
-			nit_table->area_code,
-			isdbt_mode + 1,
-			tm_name[nit_table->transmission_mode],
-			interval_name[nit_table->guard_interval]);
+				nit_table->area_code,
+				isdbt_mode + 1,
+				tm_name[nit_table->transmission_mode],
+				interval_name[nit_table->guard_interval]);
 	for (i = 2; i < dlen; i += 2) {
 		buf += 2;
 		/*
@@ -316,8 +382,8 @@ static const unsigned dvbc_dvbs_freq_inner[] = {
 };
 
 static void parse_NIT_DVBS(struct nit_table *nit_table,
-			     const unsigned char *buf, int dlen,
-			     int verbose)
+		const unsigned char *buf, int dlen,
+		int verbose)
 {
 	unsigned orbit, west;
 	uint32_t freq;
@@ -362,18 +428,18 @@ static void parse_NIT_DVBS(struct nit_table *nit_table,
 
 	if (verbose) {
 		printf("DVB-%s orbit %s, freq %d, pol %d, modulation %d, rolloff %d\n",
-		       (nit_table->delivery_system == SYS_DVBS) ? "S" : "S2",
-		       nit_table->orbit, freq,
-		       nit_table->pol, nit_table->modulation,
-		       nit_table->rolloff);
+				(nit_table->delivery_system == SYS_DVBS) ? "S" : "S2",
+				nit_table->orbit, freq,
+				nit_table->pol, nit_table->modulation,
+				nit_table->rolloff);
 		printf("Symbol rate %d, fec_inner %d\n",
-		       nit_table->symbol_rate, nit_table->fec_inner);
+				nit_table->symbol_rate, nit_table->fec_inner);
 	}
 }
 
 static void parse_NIT_DVBC(struct nit_table *nit_table,
-			     const unsigned char *buf, int dlen,
-			     int verbose)
+		const unsigned char *buf, int dlen,
+		int verbose)
 {
 	uint32_t freq;
 	static const unsigned modulation[] = {
@@ -398,17 +464,17 @@ static void parse_NIT_DVBC(struct nit_table *nit_table,
 
 	if (verbose) {
 		printf("DVB-C freq %d, modulation %d, Symbol rate %d\n",
-		       freq,
-		       nit_table->modulation,
-		       nit_table->symbol_rate);
+				freq,
+				nit_table->modulation,
+				nit_table->symbol_rate);
 		printf("fec_inner %d, fec_inner %d\n",
-		       nit_table->fec_inner, nit_table->fec_outer);
+				nit_table->fec_inner, nit_table->fec_outer);
 	}
 }
 
 static void parse_NIT_DVBT(struct nit_table *nit_table,
-			     const unsigned char *buf, int dlen,
-			     int verbose)
+		const unsigned char *buf, int dlen,
+		int verbose)
 {
 	uint32_t freq;
 	static const unsigned bw[] = {
@@ -474,21 +540,21 @@ static void parse_NIT_DVBT(struct nit_table *nit_table,
 
 	if (verbose) {
 		printf("DVB-T freq %d, bandwidth %d modulation %d\n",
-		       freq,
-		       nit_table->bandwidth,
-		       nit_table->modulation);
+				freq,
+				nit_table->bandwidth,
+				nit_table->modulation);
 		printf("hierarchy %d, code rate HP %d, LP %d, guard interval %d\n",
-		       nit_table->hierarchy,
-		       nit_table->code_rate_hp,
-		       nit_table->code_rate_lp,
-		       nit_table->guard_interval);
+				nit_table->hierarchy,
+				nit_table->code_rate_hp,
+				nit_table->code_rate_lp,
+				nit_table->guard_interval);
 		printf("transmission mode %d\n", nit_table->transmission_mode);
 	}
 }
 
 static void parse_NIT_DVBT2(struct nit_table *nit_table,
-			    const unsigned char *buf, int dlen,
-			    int verbose)
+		const unsigned char *buf, int dlen,
+		int verbose)
 {
 	static const unsigned bw[] = {
 		[0] =  8000000,
@@ -541,8 +607,8 @@ static void parse_NIT_DVBT2(struct nit_table *nit_table,
 }
 
 static void parse_freq_list(struct nit_table *nit_table,
-			    const unsigned char *buf, int dlen,
-			    int verbose)
+		const unsigned char *buf, int dlen,
+		int verbose)
 {
 	int i;
 	uint32_t freq;
@@ -560,8 +626,8 @@ static void parse_freq_list(struct nit_table *nit_table,
 }
 
 static void parse_partial_reception(struct nit_table *nit_table,
-				    const unsigned char *buf, int dlen,
-				    int verbose)
+		const unsigned char *buf, int dlen,
+		int verbose)
 {
 	int i;
 	uint16_t **pid = &nit_table->partial_reception;
@@ -573,15 +639,15 @@ static void parse_partial_reception(struct nit_table *nit_table,
 		nit_table->partial_reception[*n] = buf[i] << 8 | buf[i + 1];
 		if (verbose)
 			printf("Service 0x%04x has partial reception\n",
-			       nit_table->partial_reception[*n]);
+					nit_table->partial_reception[*n]);
 		buf += 2;
 		(*n)++;
 	}
 }
 
 static int parse_extension_descriptor(enum dvb_tables type,
-				       struct dvb_descriptors *dvb_desc,
-				       const unsigned char *buf, int dlen)
+		struct dvb_v5_descriptors *dvb_desc,
+		const unsigned char *buf, int dlen)
 {
 	unsigned char ext = buf[0];
 	int i;
@@ -595,7 +661,7 @@ static int parse_extension_descriptor(enum dvb_tables type,
 
 	if (dvb_desc->verbose) {
 		printf("Extension descriptor %s (0x%02x), len %d",
-			extension_descriptors[ext], ext, dlen);
+				extension_descriptors[ext], ext, dlen);
 		for (i = 0; i < dlen; i++) {
 			if (!(i % 16))
 				printf("\n\t");
@@ -604,23 +670,23 @@ static int parse_extension_descriptor(enum dvb_tables type,
 		printf("\n");
 	}
 	switch(ext) {
-	case T2_delivery_system_descriptor:
-		if (type != NIT)
-			return 1;
+		case T2_delivery_system_descriptor:
+			if (type != NIT)
+				return 1;
 
-		parse_NIT_DVBT2(&dvb_desc->nit_table, buf, dlen,
-				dvb_desc->verbose);
-		break;
+			parse_NIT_DVBT2(&dvb_desc->nit_table, buf, dlen,
+					dvb_desc->verbose);
+			break;
 	}
 
 	return 0;
 };
 
 static void parse_net_name(struct nit_table *nit_table,
-			   const unsigned char *buf, int dlen, int verbose)
+		const unsigned char *buf, int dlen, int verbose)
 {
 	parse_string(&nit_table->network_name, &nit_table->network_alias,
-		     &buf[2], dlen, default_charset, output_charset);
+			&buf[2], dlen, default_charset, output_charset);
 	if (verbose) {
 		printf("Network");
 		if (nit_table->network_name)
@@ -635,7 +701,7 @@ static void parse_net_name(struct nit_table *nit_table,
 
 
 static void parse_lcn(struct nit_table *nit_table,
-		      const unsigned char *buf, int dlen, int verbose)
+		const unsigned char *buf, int dlen, int verbose)
 {
 	int i, n = nit_table->lcn_len;
 	const unsigned char *p = &buf[2];
@@ -652,24 +718,24 @@ static void parse_lcn(struct nit_table *nit_table,
 
 		if (verbose)
 			printf("Service ID: 0x%04x, LCN: %d\n",
-			       (*lcn)[n].service_id,
-			       (*lcn)[n].lcn);
+					(*lcn)[n].service_id,
+					(*lcn)[n].lcn);
 	}
 }
 
 static void parse_service(struct service_table *service_table,
-			  const unsigned char *buf, int dlen, int verbose)
+		const unsigned char *buf, int dlen, int verbose)
 {
 	service_table->type = buf[2];
 	parse_string(&service_table->provider_name,
-		     &service_table->provider_alias,
-		     &buf[4], buf[3],
-		     default_charset, output_charset);
+			&service_table->provider_alias,
+			&buf[4], buf[3],
+			default_charset, output_charset);
 	buf += 4 + buf[3];
 	parse_string(&service_table->service_name,
-		     &service_table->service_alias,
-		     &buf[1], buf[0],
-		     default_charset, output_charset);
+			&service_table->service_alias,
+			&buf[1], buf[0],
+			default_charset, output_charset);
 	if (verbose) {
 		if (service_table->provider_name)
 			printf("Provider %s", service_table->provider_name);
@@ -682,17 +748,17 @@ static void parse_service(struct service_table *service_table,
 		if (service_table->service_alias)
 			printf("(%s)", service_table->service_alias);
 		if (!service_table->provider_name &&
-		    !service_table->service_alias &&
-		    !service_table->service_name &&
-		    !service_table->service_alias)
+				!service_table->service_alias &&
+				!service_table->service_name &&
+				!service_table->service_alias)
 			printf("Service 0x%04x", service_table->service_id);
 		printf("\n");
 	}
 }
 
 void parse_descriptor(enum dvb_tables type,
-			     struct dvb_descriptors *dvb_desc,
-			     const unsigned char *buf, int len)
+		struct dvb_v5_descriptors *dvb_desc,
+		const unsigned char *buf, int len)
 {
 	int i;
 
@@ -707,12 +773,12 @@ void parse_descriptor(enum dvb_tables type,
 
 		if (dlen > len) {
 			fprintf(stderr, "descriptor size %d is longer than %d!\n",
-				dlen, len);
+					dlen, len);
 			return;
 		}
 		if (dvb_desc->verbose) {
 			printf("%s (0x%02x), len %d",
-			       descriptors[buf[0]], buf[0], buf[1]);
+					dvb_descriptors[buf[0]].name, buf[0], buf[1]);
 			for (i = 0; i < dlen; i++) {
 				if (!(i % 16))
 					printf("\n\t");
@@ -721,149 +787,149 @@ void parse_descriptor(enum dvb_tables type,
 			printf("\n");
 		}
 		switch(buf[0]) {
-		case extension_descriptor:
-			err = parse_extension_descriptor(type, dvb_desc,
-							 &buf[2], dlen);
-			break;
-		case iso639_language_descriptor:
-		{
-			int i;
-			const unsigned char *p = &buf[2];
-
-			if (dvb_desc->verbose) {
-				for (i = 0; i < dlen; i+= 4, p += 4) {
-					printf("Language = %c%c%c, amode = %d\n",
-						p[0], p[1], p[2], p[3]);
-				}
-			}
-			break;
-		}
-		case AAC_descriptor:
-			if (dvb_desc->verbose)
-				printf("AAC descriptor with len %d\n", dlen);
-			break;
-		case stream_identifier_descriptor:
-			/* Don't need to parse it */
-			if (dvb_desc->verbose)
-				printf("Component tag 0x%02x\n", buf[2]);
-			break;
-		case network_name_descriptor:
-			if (type != NIT) {
-				err = 1;
+			case extension_descriptor:
+				err = parse_extension_descriptor(type, dvb_desc,
+						&buf[2], dlen);
 				break;
-			}
-			parse_net_name(&dvb_desc->nit_table, buf, dlen,
-				       dvb_desc->verbose);
-			break;
-
-		/* DVB NIT decoders */
-		case satellite_delivery_system_descriptor:
-			if (type != NIT) {
-				err = 1;
+			case iso639_language_descriptor:
+				{
+					int i;
+					const unsigned char *p = &buf[2];
+
+					if (dvb_desc->verbose) {
+						for (i = 0; i < dlen; i+= 4, p += 4) {
+							printf("Language = %c%c%c, amode = %d\n",
+									p[0], p[1], p[2], p[3]);
+						}
+					}
+					break;
+				}
+			case AAC_descriptor:
+				if (dvb_desc->verbose)
+					printf("AAC descriptor with len %d\n", dlen);
 				break;
-			}
-			parse_NIT_DVBS(&dvb_desc->nit_table, buf, dlen,
-				       dvb_desc->verbose);
-			break;
-		case cable_delivery_system_descriptor:
-			if (type != NIT) {
-				err = 1;
+			case stream_identifier_descriptor:
+				/* Don't need to parse it */
+				if (dvb_desc->verbose)
+					printf("Component tag 0x%02x\n", buf[2]);
 				break;
-			}
-			parse_NIT_DVBC(&dvb_desc->nit_table, buf, dlen,
-				       dvb_desc->verbose);
-			break;
-		case terrestrial_delivery_system_descriptor:
-			if (type != NIT) {
-				err = 1;
+			case network_name_descriptor:
+				if (type != NIT) {
+					err = 1;
+					break;
+				}
+				parse_net_name(&dvb_desc->nit_table, buf, dlen,
+						dvb_desc->verbose);
 				break;
-			}
-			parse_NIT_DVBT(&dvb_desc->nit_table, buf, dlen,
-				       dvb_desc->verbose);
-			break;
 
-		/* ISDBT NIT decoders */
-		case ISDBT_delivery_system_descriptor:
-			if (type != NIT) {
-				err = 1;
+				/* DVB NIT decoders */
+			case satellite_delivery_system_descriptor:
+				if (type != NIT) {
+					err = 1;
+					break;
+				}
+				parse_NIT_DVBS(&dvb_desc->nit_table, buf, dlen,
+						dvb_desc->verbose);
 				break;
-			}
-
-			parse_NIT_ISDBT(&dvb_desc->nit_table, buf, dlen,
-					dvb_desc->verbose);
-			break;
-		case partial_reception_descriptor:
-			if (type != NIT) {
-				err = 1;
+			case cable_delivery_system_descriptor:
+				if (type != NIT) {
+					err = 1;
+					break;
+				}
+				parse_NIT_DVBC(&dvb_desc->nit_table, buf, dlen,
+						dvb_desc->verbose);
 				break;
-			}
-			parse_partial_reception(&dvb_desc->nit_table, buf, dlen,
+			case terrestrial_delivery_system_descriptor:
+				if (type != NIT) {
+					err = 1;
+					break;
+				}
+				parse_NIT_DVBT(&dvb_desc->nit_table, buf, dlen,
 						dvb_desc->verbose);
-			break;
+				break;
 
-		/* LCN decoder */
-		case logical_channel_number_descriptor:
-		{
-			/*
-			 * According with SCTE 57 2011, descriptor 0x83
-			 * is the extended video descriptor. We don't need
-			 * it, but don't print an error for this condition.
-			 */
-			if (type == PMT)
+				/* ISDBT NIT decoders */
+			case ISDBT_delivery_system_descriptor:
+				if (type != NIT) {
+					err = 1;
+					break;
+				}
+
+				parse_NIT_ISDBT(&dvb_desc->nit_table, buf, dlen,
+						dvb_desc->verbose);
 				break;
-			if (type != NIT) {
-				err = 1;
+			case partial_reception_descriptor:
+				if (type != NIT) {
+					err = 1;
+					break;
+				}
+				parse_partial_reception(&dvb_desc->nit_table, buf, dlen,
+						dvb_desc->verbose);
 				break;
-			}
-			parse_lcn(&dvb_desc->nit_table, buf, dlen,
-				  dvb_desc->verbose);
-			break;
-		}
 
-		case TS_Information_descriptior:
-			if (type != NIT) {
-				err = 1;
-				break;
-			}
-			dvb_desc->nit_table.virtual_channel = buf[2];
-			if (dvb_desc->verbose)
-				printf("Virtual channel = %d\n", buf[2]);
-			break;
+				/* LCN decoder */
+			case logical_channel_number_descriptor:
+				{
+					/*
+					 * According with SCTE 57 2011, descriptor 0x83
+					 * is the extended video descriptor. We don't need
+					 * it, but don't print an error for this condition.
+					 */
+					if (type == PMT)
+						break;
+					if (type != NIT) {
+						err = 1;
+						break;
+					}
+					parse_lcn(&dvb_desc->nit_table, buf, dlen,
+							dvb_desc->verbose);
+					break;
+				}
 
-		case frequency_list_descriptor:
-			if (type != NIT) {
-				err = 1;
+			case TS_Information_descriptior:
+				if (type != NIT) {
+					err = 1;
+					break;
+				}
+				dvb_desc->nit_table.virtual_channel = buf[2];
+				if (dvb_desc->verbose)
+					printf("Virtual channel = %d\n", buf[2]);
 				break;
-			}
-			parse_freq_list(&dvb_desc->nit_table, buf, dlen,
-					dvb_desc->verbose);
-			break;
 
-		case service_descriptor: {
-			if (type != SDT) {
-				err = 1;
+			case frequency_list_descriptor:
+				if (type != NIT) {
+					err = 1;
+					break;
+				}
+				parse_freq_list(&dvb_desc->nit_table, buf, dlen,
+						dvb_desc->verbose);
 				break;
-			}
-			parse_service(&dvb_desc->sdt_table.service_table[dvb_desc->cur_service],
-				      buf, dlen, dvb_desc->verbose);
-			break;
-		}
-		default:
-			break;
+
+			case service_descriptor: {
+							 if (type != SDT) {
+								 err = 1;
+								 break;
+							 }
+							 parse_service(&dvb_desc->sdt_table.service_table[dvb_desc->cur_service],
+									 buf, dlen, dvb_desc->verbose);
+							 break;
+						 }
+			default:
+						 break;
 		}
 		if (err) {
 			fprintf(stderr,
-				"descriptor %s is invalid on %s table\n",
-				descriptors[buf[0]], table[type]);
+					"descriptor %s is invalid on %s table\n",
+					dvb_descriptors[buf[0]].name, table[type]);
 		}
 		buf += dlen + 2;
 		len -= dlen + 2;
 	} while (len > 0);
 }
 
-int has_descriptor(struct dvb_descriptors *dvb_desc,
-		    unsigned char needed_descriptor,
-	            const unsigned char *buf, int len)
+int has_descriptor(struct dvb_v5_descriptors *dvb_desc,
+		unsigned char needed_descriptor,
+		const unsigned char *buf, int len)
 {
 	if (len == 0)
 		return 0;
@@ -882,110 +948,110 @@ int has_descriptor(struct dvb_descriptors *dvb_desc,
 }
 
 #if 0
-	/* TODO: remove those stuff */
-
-		case ds_alignment_descriptor:
-		case dvbpsi_registration_descriptor:
-		case service_list_descriptor:
-		case stuffing_descriptor:
-		case VBI_data_descriptor:
-		case VBI_teletext_descriptor:
-		case bouquet_name_descriptor:
-		case country_availability_descriptor:
-		case linkage_descriptor:
-		case NVOD_reference_descriptor:
-		case time_shifted_service_descriptor:
-		case short_event_descriptor:
-		case extended_event_descriptor:
-		case time_shifted_event_descriptor:
-		case component_descriptor:
-		case mosaic_descriptor:
-		case CA_identifier_descriptor:
-		case content_descriptor:
-		case parental_rating_descriptor:
-		case teletext_descriptor:
-		case telephone_descriptor:
-		case local_time_offset_descriptor:
-		case subtitling_descriptor:
-		case multilingual_network_name_descriptor:
-		case multilingual_bouquet_name_descriptor:
-		case multilingual_service_name_descriptor:
-		case multilingual_component_descriptor:
-		case private_data_specifier_descriptor:
-		case service_move_descriptor:
-		case short_smoothing_buffer_descriptor:
-		case partial_transport_stream_descriptor:
-		case data_broadcast_descriptor:
-		case scrambling_descriptor:
-		case data_broadcast_id_descriptor:
-		case transport_stream_descriptor:
-		case DSNG_descriptor:
-		case PDC_descriptor:
-		case AC_3_descriptor:
-		case ancillary_data_descriptor:
-		case cell_list_descriptor:
-		case cell_frequency_link_descriptor:
-		case announcement_support_descriptor:
-		case application_signalling_descriptor:
-		case adaptation_field_data_descriptor:
-		case service_identifier_descriptor:
-		case service_availability_descriptor:
-		case default_authority_descriptor:
-		case related_content_descriptor:
-		case TVA_id_descriptor:
-		case content_identifier_descriptor:
-		case time_slice_fec_identifier_descriptor:
-		case ECM_repetition_rate_descriptor:
-		case S2_satellite_delivery_system_descriptor:
-		case enhanced_AC_3_descriptor:
-		case DTS_descriptor:
-		case XAIT_location_descriptor:
-		case FTA_content_management_descriptor:
-		case extension_descriptor:
-
-		case CUE_identifier_descriptor:
-		case component_name_descriptor:
-		case conditional_access_descriptor:
-		case copyright_descriptor:
-		case carousel_id_descriptor:
-		case association_tag_descriptor:
-		case deferred_association_tags_descriptor:
-		case AVC_video_descriptor:
-		case AVC_timing_and_HRD_descriptor:
-		case hierarchical_transmission_descriptor:
-		case digital_copy_control_descriptor:
-		case network_identifier_descriptor:
-		case partial_transport_stream_time_descriptor:
-		case audio_component_descriptor:
-		case hyperlink_descriptor:
-		case target_area_descriptor:
-		case data_contents_descriptor:
-		case video_decode_control_descriptor:
-		case download_content_descriptor:
-		case CA_EMM_TS_descriptor:
-		case CA_contract_information_descriptor:
-		case CA_service_descriptor:
-		case extended_broadcaster_descriptor:
-		case logo_transmission_descriptor:
-		case basic_local_event_descriptor:
-		case reference_descriptor:
-		case node_relation_descriptor:
-		case short_node_information_descriptor:
-		case STC_reference_descriptor:
-		case series_descriptor:
-		case event_group_descriptor:
-		case SI_parameter_descriptor:
-		case broadcaster_Name_Descriptor:
-		case component_group_descriptor:
-		case SI_prime_TS_descriptor:
-		case board_information_descriptor:
-		case LDT_linkage_descriptor:
-		case connected_transmission_descriptor:
-		case content_availability_descriptor:
-		case service_group_descriptor:
-		case carousel_compatible_composite_Descriptor:
-		case conditional_playback_descriptor:
-		case emergency_information_descriptor:
-		case data_component_descriptor:
-		case system_management_descriptor:
+/* TODO: remove those stuff */
+
+case ds_alignment_descriptor:
+case dvbpsi_registration_descriptor:
+case service_list_descriptor:
+case stuffing_descriptor:
+case VBI_data_descriptor:
+case VBI_teletext_descriptor:
+case bouquet_name_descriptor:
+case country_availability_descriptor:
+case linkage_descriptor:
+case NVOD_reference_descriptor:
+case time_shifted_service_descriptor:
+case short_event_descriptor:
+case extended_event_descriptor:
+case time_shifted_event_descriptor:
+case component_descriptor:
+case mosaic_descriptor:
+case CA_identifier_descriptor:
+case content_descriptor:
+case parental_rating_descriptor:
+case teletext_descriptor:
+case telephone_descriptor:
+case local_time_offset_descriptor:
+case subtitling_descriptor:
+case multilingual_network_name_descriptor:
+case multilingual_bouquet_name_descriptor:
+case multilingual_service_name_descriptor:
+case multilingual_component_descriptor:
+case private_data_specifier_descriptor:
+case service_move_descriptor:
+case short_smoothing_buffer_descriptor:
+case partial_transport_stream_descriptor:
+case data_broadcast_descriptor:
+case scrambling_descriptor:
+case data_broadcast_id_descriptor:
+case transport_stream_descriptor:
+case DSNG_descriptor:
+case PDC_descriptor:
+case AC_3_descriptor:
+case ancillary_data_descriptor:
+case cell_list_descriptor:
+case cell_frequency_link_descriptor:
+case announcement_support_descriptor:
+case application_signalling_descriptor:
+case adaptation_field_data_descriptor:
+case service_identifier_descriptor:
+case service_availability_descriptor:
+case default_authority_descriptor:
+case related_content_descriptor:
+case TVA_id_descriptor:
+case content_identifier_descriptor:
+case time_slice_fec_identifier_descriptor:
+case ECM_repetition_rate_descriptor:
+case S2_satellite_delivery_system_descriptor:
+case enhanced_AC_3_descriptor:
+case DTS_descriptor:
+case XAIT_location_descriptor:
+case FTA_content_management_descriptor:
+case extension_descriptor:
+
+case CUE_identifier_descriptor:
+case component_name_descriptor:
+case conditional_access_descriptor:
+case copyright_descriptor:
+case carousel_id_descriptor:
+case association_tag_descriptor:
+case deferred_association_tags_descriptor:
+case AVC_video_descriptor:
+case AVC_timing_and_HRD_descriptor:
+case hierarchical_transmission_descriptor:
+case digital_copy_control_descriptor:
+case network_identifier_descriptor:
+case partial_transport_stream_time_descriptor:
+case audio_component_descriptor:
+case hyperlink_descriptor:
+case target_area_descriptor:
+case data_contents_descriptor:
+case video_decode_control_descriptor:
+case download_content_descriptor:
+case CA_EMM_TS_descriptor:
+case CA_contract_information_descriptor:
+case CA_service_descriptor:
+case extended_broadcaster_descriptor:
+case logo_transmission_descriptor:
+case basic_local_event_descriptor:
+case reference_descriptor:
+case node_relation_descriptor:
+case short_node_information_descriptor:
+case STC_reference_descriptor:
+case series_descriptor:
+case event_group_descriptor:
+case SI_parameter_descriptor:
+case broadcaster_Name_Descriptor:
+case component_group_descriptor:
+case SI_prime_TS_descriptor:
+case board_information_descriptor:
+case LDT_linkage_descriptor:
+case connected_transmission_descriptor:
+case content_availability_descriptor:
+case service_group_descriptor:
+case carousel_compatible_composite_Descriptor:
+case conditional_playback_descriptor:
+case emergency_information_descriptor:
+case data_component_descriptor:
+case system_management_descriptor:
 #endif
diff --git a/lib/libdvbv5/descriptors.h b/lib/libdvbv5/descriptors.h
deleted file mode 100644
index 0b7f787..0000000
--- a/lib/libdvbv5/descriptors.h
+++ /dev/null
@@ -1,214 +0,0 @@
-/*
- * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation version 2
- * of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
- * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
- */
-
-/*
- * Descriptors, as defined on ETSI EN 300 468 V1.11.1 (2010-04)
- */
-
-enum dvb_tables {
-	PAT,
-	PMT,
-	NIT,
-	SDT,
-};
-
-enum descriptors {
-	/* ISO/IEC 13818-1 */
-	video_stream_descriptor				= 0x02,
-	audio_stream_descriptor				= 0x03,
-	hierarchy_descriptor				= 0x04,
-	dvbpsi_registration_descriptor			= 0x05,
-	ds_alignment_descriptor				= 0x06,
-	target_background_grid_descriptor		= 0x07,
-	video_window_descriptor				= 0x08,
-	conditional_access_descriptor			= 0x09,
-	iso639_language_descriptor			= 0x0a,
-	system_clock_descriptor				= 0x0b,
-	multiplex_buffer_utilization_descriptor		= 0x0c,
-	copyright_descriptor				= 0x0d,
-	maximum_bitrate_descriptor			= 0x0e,
-	private_data_indicator_descriptor		= 0x0f,
-	smoothing_buffer_descriptor			= 0x10,
-	std_descriptor					= 0x11,
-	ibp_descriptor					= 0x12,
-
-	mpeg4_video_descriptor				= 0x1b,
-	mpeg4_audio_descriptor				= 0x1c,
-	iod_descriptor					= 0x1d,
-	sl_descriptor					= 0x1e,
-	fmc_descriptor					= 0x1f,
-	external_es_id_descriptor			= 0x20,
-	muxcode_descriptor				= 0x21,
-	fmxbuffersize_descriptor			= 0x22,
-	multiplexbuffer_descriptor			= 0x23,
-	content_labeling_descriptor			= 0x24,
-	metadata_pointer_descriptor			= 0x25,
-	metadata_descriptor				= 0x26,
-	metadata_std_descriptor				= 0x27,
-	AVC_video_descriptor				= 0x28,
-	ipmp_descriptor					= 0x29,
-	AVC_timing_and_HRD_descriptor			= 0x2a,
-	mpeg2_aac_audio_descriptor			= 0x2b,
-	flexmux_timing_descriptor			= 0x2c,
-
-	/* ETSI EN 300 468 V1.11.1 (2010-04) */
-
-	network_name_descriptor				= 0x40,
-	service_list_descriptor				= 0x41,
-	stuffing_descriptor				= 0x42,
-	satellite_delivery_system_descriptor		= 0x43,
-	cable_delivery_system_descriptor		= 0x44,
-	VBI_data_descriptor				= 0x45,
-	VBI_teletext_descriptor				= 0x46,
-	bouquet_name_descriptor				= 0x47,
-	service_descriptor				= 0x48,
-	country_availability_descriptor			= 0x49,
-	linkage_descriptor				= 0x4a,
-	NVOD_reference_descriptor			= 0x4b,
-	time_shifted_service_descriptor			= 0x4c,
-	short_event_descriptor				= 0x4d,
-	extended_event_descriptor			= 0x4e,
-	time_shifted_event_descriptor			= 0x4f,
-	component_descriptor				= 0x50,
-	mosaic_descriptor				= 0x51,
-	stream_identifier_descriptor			= 0x52,
-	CA_identifier_descriptor			= 0x53,
-	content_descriptor				= 0x54,
-	parental_rating_descriptor			= 0x55,
-	teletext_descriptor				= 0x56,
-	telephone_descriptor				= 0x57,
-	local_time_offset_descriptor			= 0x58,
-	subtitling_descriptor				= 0x59,
-	terrestrial_delivery_system_descriptor		= 0x5a,
-	multilingual_network_name_descriptor		= 0x5b,
-	multilingual_bouquet_name_descriptor		= 0x5c,
-	multilingual_service_name_descriptor		= 0x5d,
-	multilingual_component_descriptor		= 0x5e,
-	private_data_specifier_descriptor		= 0x5f,
-	service_move_descriptor				= 0x60,
-	short_smoothing_buffer_descriptor		= 0x61,
-	frequency_list_descriptor			= 0x62,
-	partial_transport_stream_descriptor		= 0x63,
-	data_broadcast_descriptor			= 0x64,
-	scrambling_descriptor				= 0x65,
-	data_broadcast_id_descriptor			= 0x66,
-	transport_stream_descriptor			= 0x67,
-	DSNG_descriptor					= 0x68,
-	PDC_descriptor					= 0x69,
-	AC_3_descriptor					= 0x6a,
-	ancillary_data_descriptor			= 0x6b,
-	cell_list_descriptor				= 0x6c,
-	cell_frequency_link_descriptor			= 0x6d,
-	announcement_support_descriptor			= 0x6e,
-	application_signalling_descriptor		= 0x6f,
-	adaptation_field_data_descriptor		= 0x70,
-	service_identifier_descriptor			= 0x71,
-	service_availability_descriptor			= 0x72,
-	default_authority_descriptor			= 0x73,
-	related_content_descriptor			= 0x74,
-	TVA_id_descriptor				= 0x75,
-	content_identifier_descriptor			= 0x76,
-	time_slice_fec_identifier_descriptor		= 0x77,
-	ECM_repetition_rate_descriptor			= 0x78,
-	S2_satellite_delivery_system_descriptor		= 0x79,
-	enhanced_AC_3_descriptor			= 0x7a,
-	DTS_descriptor					= 0x7b,
-	AAC_descriptor					= 0x7c,
-	XAIT_location_descriptor			= 0x7d,
-	FTA_content_management_descriptor		= 0x7e,
-	extension_descriptor				= 0x7f,
-
-	/* SCTE 35 2004 */
-	CUE_identifier_descriptor			= 0x8a,
-
-	/* From http://www.etherguidesystems.com/Help/SDOs/ATSC/Semantics/Descriptors/Default.aspx */
-	component_name_descriptor			= 0xa3,
-
-	/* From http://www.coolstf.com/tsreader/descriptors.html */
-	logical_channel_number_descriptor		= 0x83,
-
-	/* ISDB Descriptors, as defined on ABNT NBR 15603-1 2007 */
-
-	carousel_id_descriptor				= 0x13,
-	association_tag_descriptor			= 0x14,
-	deferred_association_tags_descriptor		= 0x15,
-
-	hierarchical_transmission_descriptor		= 0xc0,
-	digital_copy_control_descriptor			= 0xc1,
-	network_identifier_descriptor			= 0xc2,
-	partial_transport_stream_time_descriptor	= 0xc3,
-	audio_component_descriptor			= 0xc4,
-	hyperlink_descriptor				= 0xc5,
-	target_area_descriptor				= 0xc6,
-	data_contents_descriptor			= 0xc7,
-	video_decode_control_descriptor			= 0xc8,
-	download_content_descriptor			= 0xc9,
-	CA_EMM_TS_descriptor				= 0xca,
-	CA_contract_information_descriptor		= 0xcb,
-	CA_service_descriptor				= 0xcc,
-	TS_Information_descriptior			= 0xcd,
-	extended_broadcaster_descriptor			= 0xce,
-	logo_transmission_descriptor			= 0xcf,
-	basic_local_event_descriptor			= 0xd0,
-	reference_descriptor				= 0xd1,
-	node_relation_descriptor			= 0xd2,
-	short_node_information_descriptor		= 0xd3,
-	STC_reference_descriptor			= 0xd4,
-	series_descriptor				= 0xd5,
-	event_group_descriptor				= 0xd6,
-	SI_parameter_descriptor				= 0xd7,
-	broadcaster_Name_Descriptor			= 0xd8,
-	component_group_descriptor			= 0xd9,
-	SI_prime_TS_descriptor				= 0xda,
-	board_information_descriptor			= 0xdb,
-	LDT_linkage_descriptor				= 0xdc,
-	connected_transmission_descriptor		= 0xdd,
-	content_availability_descriptor			= 0xde,
-	service_group_descriptor			= 0xe0,
-	carousel_compatible_composite_Descriptor	= 0xf7,
-	conditional_playback_descriptor			= 0xf8,
-	ISDBT_delivery_system_descriptor		= 0xfa,
-	partial_reception_descriptor			= 0xfb,
-	emergency_information_descriptor		= 0xfc,
-	data_component_descriptor			= 0xfd,
-	system_management_descriptor			= 0xfe,
-};
-
-enum extension_descriptors {
-	image_icon_descriptor				= 0x00,
-	cpcm_delivery_signalling_descriptor		= 0x01,
-	CP_descriptor					= 0x02,
-	CP_identifier_descriptor			= 0x03,
-	T2_delivery_system_descriptor			= 0x04,
-	SH_delivery_system_descriptor			= 0x05,
-	supplementary_audio_descriptor			= 0x06,
-	network_change_notify_descriptor		= 0x07,
-	message_descriptor				= 0x08,
-	target_region_descriptor			= 0x09,
-	target_region_name_descriptor			= 0x0a,
-	service_relocated_descriptor			= 0x0b,
-};
-
-void parse_descriptor(enum dvb_tables type,
-		      struct dvb_descriptors *dvb_desc,
-		      const unsigned char *buf, int len);
-
-int has_descriptor(struct dvb_descriptors *dvb_desc,
-		    unsigned char needed_descriptor,
-	            const unsigned char *buf, int len);
diff --git a/lib/libdvbv5/descriptors/desc_cable_delivery.c b/lib/libdvbv5/descriptors/desc_cable_delivery.c
new file mode 100644
index 0000000..52c5f70
--- /dev/null
+++ b/lib/libdvbv5/descriptors/desc_cable_delivery.c
@@ -0,0 +1,53 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "descriptors/desc_cable_delivery.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+
+ssize_t dvb_desc_cable_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	struct dvb_desc_cable_delivery *cable = (struct dvb_desc_cable_delivery *) desc;
+	/* copy only the data - length already initialize */
+	memcpy(((uint8_t *) cable ) + sizeof(cable->type) + sizeof(cable->next) + sizeof(cable->length),
+			buf,
+			cable->length);
+	bswap32(cable->frequency);
+	bswap16(cable->bitfield1);
+	bswap32(cable->bitfield2);
+	cable->frequency   = bcd(cable->frequency) * 100;
+	cable->symbol_rate = bcd(cable->symbol_rate) * 100;
+
+	return sizeof(struct dvb_desc_cable_delivery);
+}
+
+void dvb_desc_cable_delivery_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+{
+	const struct dvb_desc_cable_delivery *cable = (const struct dvb_desc_cable_delivery *) desc;
+	dvb_log("|        cable delivery");
+	dvb_log("|           length            %d", cable->length);
+	dvb_log("|           frequency         %d", cable->frequency);
+	dvb_log("|           fec outer         %d", cable->fec_outer);
+	dvb_log("|           modulation        %d", cable->modulation);
+	dvb_log("|           symbol_rate       %d", cable->symbol_rate);
+	dvb_log("|           fec inner         %d", cable->fec_inner);
+}
+
diff --git a/lib/libdvbv5/descriptors/desc_frequency_list.c b/lib/libdvbv5/descriptors/desc_frequency_list.c
new file mode 100644
index 0000000..acf8563
--- /dev/null
+++ b/lib/libdvbv5/descriptors/desc_frequency_list.c
@@ -0,0 +1,63 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "descriptors/desc_frequency_list.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+
+ssize_t dvb_desc_frequency_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	struct dvb_desc_frequency_list *flist = (struct dvb_desc_frequency_list *) desc;
+
+	flist->bitfield = buf[0];
+
+	flist->frequencies = (flist->length - sizeof(flist->bitfield)) / sizeof(flist->frequency[0]);
+	int i;
+	for (i = 1; i <= flist->frequencies; i++) {
+		flist->frequency[i] = ((uint32_t *) buf)[i];
+		bswap32(flist->frequency[i]);
+		switch (flist->freq_type) {
+			case 1: /* satellite - to get kHz*/
+			case 3: /* terrestrial - to get Hz*/
+				flist->frequency[i] *= 10;
+				break;
+			case 2: /* cable - to get Hz */
+				flist->frequency[i] *= 100;
+				break;
+			case 0: /* not defined */
+			default:
+				break;
+		}
+	}
+
+	return sizeof(struct dvb_desc_frequency_list) + (flist->frequencies * sizeof(flist->frequency[0]));
+}
+
+void dvb_desc_frequency_list_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+{
+	const struct dvb_desc_frequency_list *flist = (const struct dvb_desc_frequency_list *) desc;
+	dvb_log("|       frequency list type: %d", flist->freq_type);
+	int i = 0;
+	for (i = 0; i < flist->frequencies; i++) {
+		dvb_log("|       frequency : %d", flist->frequency[i]);
+	}
+}
+
diff --git a/lib/libdvbv5/descriptors/desc_language.c b/lib/libdvbv5/descriptors/desc_language.c
new file mode 100644
index 0000000..686bcd4
--- /dev/null
+++ b/lib/libdvbv5/descriptors/desc_language.c
@@ -0,0 +1,44 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "descriptors/desc_language.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+
+ssize_t dvb_desc_language_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	struct dvb_desc_language *lang = (struct dvb_desc_language *) desc;
+
+	lang->language[0] = buf[0];
+	lang->language[1] = buf[1];
+	lang->language[2] = buf[2];
+	lang->language[3] = '\0';
+	lang->audio_type  = buf[3];
+
+	return sizeof(struct dvb_desc_language);
+}
+
+void dvb_desc_language_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+{
+	const struct dvb_desc_language *lang = (const struct dvb_desc_language *) desc;
+	dvb_log("|                   lang: %s (type: %d)", lang->language, lang->audio_type);
+}
+
diff --git a/lib/libdvbv5/descriptors/desc_network_name.c b/lib/libdvbv5/descriptors/desc_network_name.c
new file mode 100644
index 0000000..10e18c3
--- /dev/null
+++ b/lib/libdvbv5/descriptors/desc_network_name.c
@@ -0,0 +1,41 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "descriptors/desc_network_name.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+
+ssize_t dvb_desc_network_name_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	struct dvb_desc_network_name *net = (struct dvb_desc_network_name *) desc;
+
+	memcpy(net->network_name, buf, net->length);
+	net->network_name[net->length] = '\0';
+
+	return sizeof(struct dvb_desc_network_name) + net->length + sizeof(net->network_name[0]);
+}
+
+void dvb_desc_network_name_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+{
+	const struct dvb_desc_network_name *net = (const struct dvb_desc_network_name *) desc;
+	dvb_log("|           network name: '%s'", net->network_name);
+}
+
diff --git a/lib/libdvbv5/descriptors/desc_sat.c b/lib/libdvbv5/descriptors/desc_sat.c
new file mode 100644
index 0000000..e07ad1d
--- /dev/null
+++ b/lib/libdvbv5/descriptors/desc_sat.c
@@ -0,0 +1,69 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "descriptors/desc_sat.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+
+ssize_t dvb_desc_sat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	struct dvb_desc_sat *sat = (struct dvb_desc_sat *) desc;
+	/* copy from .length */
+	memcpy(((uint8_t *) sat ) + sizeof(sat->type) + sizeof(sat->next) + sizeof(sat->length),
+		buf,
+		sat->length);
+	bswap16(sat->orbit);
+	bswap32(sat->bitfield);
+	bswap32(sat->frequency);
+	sat->orbit = bcd(sat->orbit);
+	sat->frequency   = bcd(sat->frequency) * 10;
+	sat->symbol_rate = bcd(sat->symbol_rate) * 100;
+
+	return sizeof(struct dvb_desc_sat);
+}
+
+void dvb_desc_sat_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+{
+	const struct dvb_desc_sat *sat = (const struct dvb_desc_sat *) desc;
+	char pol;
+	switch(sat->polarization) {
+		case 0:
+			pol = 'H';
+			break;
+		case 1:
+			pol = 'V';
+			break;
+		case 2:
+			pol = 'L';
+			break;
+		case 3:
+			pol = 'R';
+			break;
+	}
+	dvb_log("|           modulation_system %s", sat->modulation_system ? "DVB-S2" : "DVB-S");
+	dvb_log("|           frequency         %d %c", sat->frequency, pol);
+	dvb_log("|           symbol_rate       %d", sat->symbol_rate);
+	dvb_log("|           fec               %d", sat->fec);
+	dvb_log("|           modulation_type   %d", sat->modulation_type);
+	dvb_log("|           roll_off          %d", sat->roll_off);
+	dvb_log("|           orbit             %.1f %c", (float) sat->orbit / 10.0, sat->west_east ? 'E' : 'W');
+}
+
diff --git a/lib/libdvbv5/descriptors/desc_service.c b/lib/libdvbv5/descriptors/desc_service.c
new file mode 100644
index 0000000..0507e5c
--- /dev/null
+++ b/lib/libdvbv5/descriptors/desc_service.c
@@ -0,0 +1,56 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "descriptors/desc_service.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+
+ssize_t dvb_desc_service_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	struct dvb_desc_service *service = (struct dvb_desc_service *) desc;
+
+	service->service_type = buf[0];
+	buf++;
+
+	service->provider = ((char *) desc) + sizeof(struct dvb_desc_service);
+	uint8_t len1 = buf[0];
+	buf++;
+	memcpy(service->provider, buf, len1);
+	service->provider[len1] = '\0';
+	buf += len1;
+
+	service->name = service->provider + len1 + 1;
+	uint8_t len2 = buf[0];
+	buf++;
+	memcpy(service->name, buf, len2);
+	service->name[len2] = '\0';
+
+	return sizeof(struct dvb_desc_service) + len1 + 1 + len2 + 1;
+}
+
+void dvb_desc_service_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+{
+	const struct dvb_desc_service *srv = (const struct dvb_desc_service *) desc;
+	dvb_log("|           type    : '%d'", srv->service_type);
+	dvb_log("|           name    : '%s'", srv->name);
+	dvb_log("|           provider: '%s'", srv->provider);
+}
+
diff --git a/lib/libdvbv5/descriptors/desc_service_list.c b/lib/libdvbv5/descriptors/desc_service_list.c
new file mode 100644
index 0000000..41084bd
--- /dev/null
+++ b/lib/libdvbv5/descriptors/desc_service_list.c
@@ -0,0 +1,53 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "descriptors/desc_service_list.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+
+ssize_t dvb_desc_service_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	struct dvb_desc_service_list *slist = (struct dvb_desc_service_list *) desc;
+
+	memcpy( slist->services, buf, slist->length);
+	/* close the list */
+	slist->services[slist->length / sizeof(struct dvb_desc_service_list_table)].service_id = 0;
+	slist->services[slist->length / sizeof(struct dvb_desc_service_list_table)].service_type = 0;
+	/* swap the ids */
+	int i;
+	for( i = 0; slist->services[i].service_id != 0; ++i) {
+		bswap16(slist->services[i].service_id);
+	}
+
+	return sizeof(struct dvb_desc_service_list) + slist->length + sizeof(struct dvb_desc_service_list_table);
+}
+
+void dvb_desc_service_list_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+{
+	const struct dvb_desc_service_list *slist = (const struct dvb_desc_service_list *) desc;
+	int i = 0;
+	while(slist->services[i].service_id != 0) {
+		dvb_log("|           service id   : '%d'", slist->services[i].service_id);
+		dvb_log("|           service type : '%d'", slist->services[i].service_type);
+		++i;
+	}
+}
+
diff --git a/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c b/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
new file mode 100644
index 0000000..844b34c
--- /dev/null
+++ b/lib/libdvbv5/descriptors/desc_terrestrial_delivery.c
@@ -0,0 +1,57 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "descriptors/desc_terrestrial_delivery.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+
+ssize_t dvb_desc_terrestrial_delivery_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
+{
+	struct dvb_desc_terrestrial_delivery *tdel = (struct dvb_desc_terrestrial_delivery *) desc;
+	/* copy from .length */
+	memcpy(((uint8_t *) tdel ) + sizeof(tdel->type) + sizeof(tdel->next) + sizeof(tdel->length),
+			buf,
+			tdel->length);
+	bswap32(tdel->centre_frequency);
+	bswap32(tdel->reserved_future_use2);
+
+	return sizeof(struct dvb_desc_terrestrial_delivery);
+}
+
+void dvb_desc_terrestrial_delivery_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
+{
+	const struct dvb_desc_terrestrial_delivery *tdel = (const struct dvb_desc_terrestrial_delivery *) desc;
+	dvb_log("|       terrestrial delivery");
+	dvb_log("|           length                %d", tdel->length);
+	dvb_log("|           centre frequency      %d", tdel->centre_frequency);
+	dvb_log("|           mpe_fec_indicator     %d", tdel->mpe_fec_indicator);
+	dvb_log("|           time_slice_indicator  %d", tdel->time_slice_indicator);
+	dvb_log("|           priority              %d", tdel->priority);
+	dvb_log("|           bandwidth             %d", tdel->bandwidth);
+	dvb_log("|           code_rate_hp_stream   %d", tdel->code_rate_hp_stream);
+	dvb_log("|           hierarchy_information %d", tdel->hierarchy_information);
+	dvb_log("|           constellation         %d", tdel->constellation);
+	dvb_log("|           other_frequency_flag  %d", tdel->other_frequency_flag);
+	dvb_log("|           transmission_mode     %d", tdel->transmission_mode);
+	dvb_log("|           guard_interval        %d", tdel->guard_interval);
+	dvb_log("|           code_rate_lp_stream   %d", tdel->code_rate_lp_stream);
+}
+
diff --git a/lib/libdvbv5/descriptors/header.c b/lib/libdvbv5/descriptors/header.c
new file mode 100644
index 0000000..d371eec
--- /dev/null
+++ b/lib/libdvbv5/descriptors/header.c
@@ -0,0 +1,48 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "descriptors/header.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+
+int dvb_table_header_init(struct dvb_table_header *t)
+{
+	bswap16(t->bitfield);
+	bswap16(t->id);
+	return 0;
+}
+
+void dvb_table_header_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_header *t)
+{
+	dvb_log("| table_id       %d", t->table_id);
+	dvb_log("| section_length %d", t->section_length);
+	dvb_log("| zero           %d", t->zero);
+	dvb_log("| one            %d", t->one);
+	dvb_log("| zero2          %d", t->zero2);
+	dvb_log("| syntax         %d", t->syntax);
+	dvb_log("| id             %d", t->id);
+	dvb_log("| current_next   %d", t->current_next);
+	dvb_log("| version        %d", t->version);
+	dvb_log("| one2           %d", t->one2);
+	dvb_log("| section_id     %d", t->section_id);
+	dvb_log("| last_section   %d", t->last_section);
+}
+
diff --git a/lib/libdvbv5/descriptors/nit.c b/lib/libdvbv5/descriptors/nit.c
new file mode 100644
index 0000000..1a429bb
--- /dev/null
+++ b/lib/libdvbv5/descriptors/nit.c
@@ -0,0 +1,100 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "descriptors/nit.h"
+#include "dvb-fe.h"
+
+void *dvb_table_nit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t size)
+{
+	uint8_t *d = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE * 2);
+	const uint8_t *p = buf;
+	struct dvb_table_nit *nit = (struct dvb_table_nit *) d;
+
+	memcpy(nit, p, sizeof(struct dvb_table_nit) - sizeof(nit->descriptor) - sizeof(nit->transport));
+	p += sizeof(struct dvb_table_nit) - sizeof(nit->descriptor) - sizeof(nit->transport);
+	d += sizeof(struct dvb_table_nit);
+
+	dvb_table_header_init(&nit->header);
+	bswap16(nit->bitfield);
+	nit->descriptor = NULL;
+	nit->transport = NULL;
+
+	d += dvb_parse_descriptors(parms, p, d, nit->desc_length, &nit->descriptor);
+	p += nit->desc_length;
+
+	p += sizeof(union dvb_table_nit_transport_header);
+
+	struct dvb_table_nit_transport *last = NULL;
+	struct dvb_table_nit_transport **head = &nit->transport;
+	while ((uint8_t *) p < buf + size - 4) {
+		struct dvb_table_nit_transport *transport = (struct dvb_table_nit_transport *) d;
+		memcpy(d, p, sizeof(struct dvb_table_nit_transport) - sizeof(transport->descriptor) - sizeof(transport->next));
+		p += sizeof(struct dvb_table_nit_transport) - sizeof(transport->descriptor) - sizeof(transport->next);
+		d += sizeof(struct dvb_table_nit_transport);
+
+		bswap16(transport->transport_id);
+		bswap16(transport->network_id);
+		bswap16(transport->bitfield);
+		transport->descriptor = NULL;
+		transport->next = NULL;
+
+		if(!*head)
+			*head = transport;
+		if(last)
+			last->next = transport;
+
+		/* get the descriptors for each transport */
+		struct dvb_desc **head_desc = &transport->descriptor;
+		d += dvb_parse_descriptors(parms, p, d, transport->section_length, head_desc);
+
+		p += transport->section_length;
+		last = transport;
+	}
+	return nit;
+}
+
+void dvb_table_nit_print(struct dvb_v5_fe_parms *parms, struct dvb_table_nit *nit)
+{
+	dvb_log("NIT");
+	dvb_table_header_print(parms, &nit->header);
+	dvb_log("| desc_length   %d", nit->desc_length);
+	struct dvb_desc *desc = nit->descriptor;
+	while (desc) {
+		if (dvb_descriptors[desc->type].print)
+			dvb_descriptors[desc->type].print(parms, desc);
+		desc = desc->next;
+	}
+	const struct dvb_table_nit_transport *transport = nit->transport;
+	uint16_t transports = 0;
+	while(transport) {
+		dvb_log("|- Transport: %-7d Network: %-7d", transport->transport_id, transport->network_id);
+		desc = transport->descriptor;
+		while (desc) {
+			if (dvb_descriptors[desc->type].print)
+				dvb_descriptors[desc->type].print(parms, desc);
+			desc = desc->next;
+		}
+		transport = transport->next;
+		transports++;
+	}
+	dvb_log("|_  %d transports", transports);
+}
+
diff --git a/lib/libdvbv5/descriptors/pat.c b/lib/libdvbv5/descriptors/pat.c
new file mode 100644
index 0000000..d1fb30b
--- /dev/null
+++ b/lib/libdvbv5/descriptors/pat.c
@@ -0,0 +1,57 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "descriptors/pat.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+
+void *dvb_table_pat_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t size)
+{
+	struct dvb_table_pat *pat = malloc(size + sizeof(uint16_t));
+	memcpy(pat, buf, sizeof(struct dvb_table_pat) - sizeof(uint16_t));
+
+	dvb_table_header_init(&pat->header);
+
+	struct dvb_table_pat_program *p = (struct dvb_table_pat_program *)
+		                          (buf + sizeof(struct dvb_table_pat) - sizeof(uint16_t));
+	int i = 0;
+	while ((uint8_t *) p < buf + size - 4) {
+		memcpy(pat->program + i, p, sizeof(struct dvb_table_pat_program));
+		bswap16(pat->program[i].program_id);
+		bswap16(pat->program[i].bitfield);
+		p++;
+		i++;
+	}
+	pat->programs = i;
+	return pat;
+}
+
+void dvb_table_pat_print(struct dvb_v5_fe_parms *parms, struct dvb_table_pat *t)
+{
+	dvb_log("PAT");
+	dvb_table_header_print(parms, &t->header);
+	dvb_log("|\\   pid     program_id (%d programs)", t->programs);
+	int i;
+	for (i = 0; i < t->programs; i++) {
+		dvb_log("|- %7d %7d", t->program[i].pid, t->program[i].program_id);
+	}
+}
+
diff --git a/lib/libdvbv5/descriptors/pmt.c b/lib/libdvbv5/descriptors/pmt.c
new file mode 100644
index 0000000..293a970
--- /dev/null
+++ b/lib/libdvbv5/descriptors/pmt.c
@@ -0,0 +1,103 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "descriptors/pmt.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+
+#include <string.h> /* memcpy */
+
+void *dvb_table_pmt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t size)
+{
+	uint8_t *d = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE * 2);
+	const uint8_t *p = buf;
+	struct dvb_table_pmt *pmt = (struct dvb_table_pmt *) d;
+
+	memcpy(pmt, p, sizeof(struct dvb_table_pmt) - sizeof(pmt->stream));
+	p += sizeof(struct dvb_table_pmt) - sizeof(pmt->stream);
+	d += sizeof(struct dvb_table_pmt);
+
+	dvb_table_header_init(&pmt->header);
+	bswap16(pmt->bitfield);
+	bswap16(pmt->bitfield2);
+	pmt->stream = NULL;
+
+	/* skip prog section */
+	p += pmt->prog_length;
+
+	/* get the stream entries */
+	struct dvb_table_pmt_stream *last = NULL;
+	struct dvb_table_pmt_stream **head = &pmt->stream;
+	while (p < buf + size - 4) {
+		struct dvb_table_pmt_stream *stream = (struct dvb_table_pmt_stream *) d;
+		memcpy(d, p, sizeof(struct dvb_table_pmt_stream) - sizeof(stream->descriptor) - sizeof(stream->next));
+		p += sizeof(struct dvb_table_pmt_stream) - sizeof(stream->descriptor) - sizeof(stream->next);
+		d += sizeof(struct dvb_table_pmt_stream);
+
+		bswap16(stream->bitfield);
+		bswap16(stream->bitfield2);
+		stream->descriptor = NULL;
+		stream->next = NULL;
+
+		if(!*head)
+			*head = stream;
+		if(last)
+			last->next = stream;
+
+		/* get the descriptors for each program */
+		struct dvb_desc **head_desc = &stream->descriptor;
+		d += dvb_parse_descriptors(parms, p, d, stream->section_length, head_desc);
+
+		p += stream->section_length;
+		last = stream;
+	}
+
+	// FIXME: realloc
+	return pmt;
+}
+
+void dvb_table_pmt_print(struct dvb_v5_fe_parms *parms, const struct dvb_table_pmt *pmt)
+{
+	dvb_log( "PMT" );
+	dvb_table_header_print(parms, &pmt->header);
+	dvb_log( "|- pcr_pid       %d", pmt->pcr_pid );
+	dvb_log( "|  reserved2     %d", pmt->reserved2 );
+	dvb_log( "|  prog length   %d", pmt->prog_length );
+	dvb_log( "|  zero3         %d", pmt->zero3 );
+	dvb_log( "|  reserved3     %d", pmt->reserved3 );
+	dvb_log("|\\  pid     len   type");
+	const struct dvb_table_pmt_stream *stream = pmt->stream;
+	uint16_t streams = 0;
+	while(stream) {
+		dvb_log("|- %5d    %4d  %s (%d)", stream->elementary_pid, stream->section_length,
+				dvb_descriptors[stream->type].name, stream->type);
+		struct dvb_desc *desc = stream->descriptor;
+		while (desc) {
+			if (dvb_descriptors[desc->type].print)
+				dvb_descriptors[desc->type].print(parms, desc);
+			desc = desc->next;
+		}
+		stream = stream->next;
+		streams++;
+	}
+	dvb_log("|_  %d streams", streams);
+}
+
diff --git a/lib/libdvbv5/descriptors/sdt.c b/lib/libdvbv5/descriptors/sdt.c
new file mode 100644
index 0000000..e9d576b
--- /dev/null
+++ b/lib/libdvbv5/descriptors/sdt.c
@@ -0,0 +1,88 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "descriptors/sdt.h"
+#include "dvb-fe.h"
+
+void *dvb_table_sdt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t size)
+{
+	uint8_t *d = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE * 2);
+	const uint8_t *p = buf;
+	struct dvb_table_sdt *sdt = (struct dvb_table_sdt *) d;
+
+	memcpy(sdt, p, sizeof(struct dvb_table_sdt) - sizeof(sdt->service));
+	p += sizeof(struct dvb_table_sdt) - sizeof(sdt->service);
+	d += sizeof(struct dvb_table_sdt);
+
+	dvb_table_header_init(&sdt->header);
+	sdt->service = NULL;
+
+	struct dvb_table_sdt_service *last = NULL;
+	struct dvb_table_sdt_service **head = &sdt->service;
+	while ((uint8_t *) p < buf + size - 4) {
+		struct dvb_table_sdt_service *service = (struct dvb_table_sdt_service *) d;
+		memcpy(d, p, sizeof(struct dvb_table_sdt_service) - sizeof(service->descriptor) - sizeof(service->next));
+		p += sizeof(struct dvb_table_sdt_service) - sizeof(service->descriptor) - sizeof(service->next);
+		d += sizeof(struct dvb_table_sdt_service);
+
+		bswap16(service->service_id);
+		bswap16(service->bitfield);
+		service->descriptor = NULL;
+		service->next = NULL;
+
+		if(!*head)
+			*head = service;
+		if(last)
+			last->next = service;
+
+		/* get the descriptors for each program */
+		struct dvb_desc **head_desc = &service->descriptor;
+		d += dvb_parse_descriptors(parms, p, d, service->section_length, head_desc);
+
+		p += service->section_length;
+		last = service;
+	}
+	return sdt;
+}
+
+void dvb_table_sdt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_sdt *sdt)
+{
+	dvb_log("SDT");
+	dvb_table_header_print(parms, &sdt->header);
+	dvb_log("|\\  service_id");
+	const struct dvb_table_sdt_service *service = sdt->service;
+	uint16_t services = 0;
+	while(service) {
+		dvb_log("|- %7d", service->service_id);
+		dvb_log("|   EIT_schedule: %d", service->EIT_schedule);
+		dvb_log("|   EIT_present_following: %d", service->EIT_present_following);
+		struct dvb_desc *desc = service->descriptor;
+		while (desc) {
+			if (dvb_descriptors[desc->type].print)
+				dvb_descriptors[desc->type].print(parms, desc);
+			desc = desc->next;
+		}
+		service = service->next;
+		services++;
+	}
+	dvb_log("|_  %d services", services);
+}
+
diff --git a/lib/libdvbv5/dvb-demux.c b/lib/libdvbv5/dvb-demux.c
index f7157d7..7ece976 100644
--- a/lib/libdvbv5/dvb-demux.c
+++ b/lib/libdvbv5/dvb-demux.c
@@ -36,10 +36,26 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
-    
+#include <stdlib.h> /* free */
+
 #include <linux/dvb/dmx.h>
 #include "dvb-demux.h"
 
+int dvb_dmx_open(int adapter, int demux, unsigned verbose)
+{
+  char* demux_name = NULL;
+  asprintf(&demux_name, "/dev/dvb/adapter%i/demux%i", adapter, demux );
+  int fd_demux = open( demux_name, O_RDWR );
+  free( demux_name );
+  return fd_demux;
+}
+
+void dvb_dmx_close(int dmx_fd)
+{
+  (void) ioctl( dmx_fd, DMX_STOP);
+  close( dmx_fd);
+}
+
 int set_pesfilter(int dmxfd, int pid, int pes_type, int dvr)
 {
 	struct dmx_pes_filter_params pesfilter;
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 9b18226..9ff5b7b 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -23,45 +23,7 @@
 #include "dvb-fe.h"
 
 #include <stddef.h>
-#include <stdio.h>
 #include <unistd.h>
-#include <stdarg.h>
-
-static const struct loglevel {
-	const char *name;
-	const char *color;
-	int fd;
-} loglevels[9] = {
-	{"EMERG   ", "\033[31m", STDERR_FILENO },
-	{"ALERT   ", "\033[31m", STDERR_FILENO },
-	{"CRITICAL", "\033[31m", STDERR_FILENO },
-	{"ERROR   ", "\033[31m", STDERR_FILENO },
-	{"WARNING ", "\033[33m", STDOUT_FILENO },
-	{"NOTICE  ", "\033[36m", STDOUT_FILENO },
-	{"INFO    ", "\033[36m", STDOUT_FILENO },
-	{"DEBUG   ", "\033[32m", STDOUT_FILENO },
-	{"",         "\033[0m",  STDOUT_FILENO },
-};
-#define LOG_COLOROFF 8
-
-void dvb_default_log(int level, const char *fmt, ...)
-{
-	if(level > sizeof(loglevels) / sizeof(struct loglevel) - 2) // ignore LOG_COLOROFF as well
-		level = LOG_INFO;
-	va_list ap;
-	va_start(ap, fmt);
-	FILE *out = stdout;
-	if(STDERR_FILENO == loglevels[level].fd)
-		out = stderr;
-	if(isatty(loglevels[level].fd))
-		fputs(loglevels[level].color, out);
-	fprintf(out, "%s ", loglevels[level].name);
-	vfprintf(out, fmt, ap);
-	fprintf(out, "\n");
-	if(isatty(loglevels[level].fd))
-		fputs(loglevels[LOG_COLOROFF].color, out);
-	va_end(ap);
-}
 
 static void dvb_v5_free(struct dvb_v5_fe_parms *parms)
 {
@@ -451,7 +413,7 @@ const char *dvb_cmd_name(int cmd)
 	return NULL;
 }
 
-const char * const *dvb_attr_names(int cmd)
+const char *const *dvb_attr_names(int cmd)
 {
 	if (cmd >= 0 && cmd < DTV_USER_COMMAND_START)
 		return dvb_v5_attr_names[cmd];
@@ -460,7 +422,7 @@ const char * const *dvb_attr_names(int cmd)
 	return NULL;
 }
 
-void dvb_fe_prt_parms(FILE *fp, const struct dvb_v5_fe_parms *parms)
+void dvb_fe_prt_parms(const struct dvb_v5_fe_parms *parms)
 {
 	int i;
 
@@ -477,11 +439,11 @@ void dvb_fe_prt_parms(FILE *fp, const struct dvb_v5_fe_parms *parms)
 		}
 
 		if (!attr_name || !*attr_name)
-			fprintf(fp, "%s = %u\n",
+			dvb_log("%s = %u",
 				dvb_cmd_name(parms->dvb_prop[i].cmd),
 				parms->dvb_prop[i].u.data);
 		else
-			fprintf(fp, "%s = %s\n",
+			dvb_log("%s = %s",
 				dvb_cmd_name(parms->dvb_prop[i].cmd),
 				*attr_name);
 	}
@@ -563,9 +525,9 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *parms)
 			return errno;
 		}
 		if (parms->verbose) {
-			printf("Got parameters for %s:\n",
+			dvb_log("Got parameters for %s:",
 			       delivery_system_name[parms->current_sys]);
-			dvb_fe_prt_parms(stdout, parms);
+			dvb_fe_prt_parms(parms);
 		}
 		goto ret;
 	}
@@ -640,7 +602,7 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms)
 		if (ioctl(parms->fd, FE_SET_PROPERTY, &prop) == -1) {
 			dvb_perror("FE_SET_PROPERTY");
 			if (parms->verbose)
-				dvb_fe_prt_parms(stderr, parms);
+				dvb_fe_prt_parms(parms);
 			return errno;
 		}
 		goto ret;
@@ -682,7 +644,7 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms)
 	if (ioctl(parms->fd, FE_SET_FRONTEND, &v3_parms) == -1) {
 		dvb_perror("FE_SET_FRONTEND");
 		if (parms->verbose)
-			dvb_fe_prt_parms(stderr, parms);
+			dvb_fe_prt_parms(parms);
 		return errno;
 	}
 ret:
diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index ea9caa0..2c8905e 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -720,11 +720,11 @@ int write_dvb_file(const char *fname, struct dvb_file *dvb_file)
 
 			if (!attr_name || !*attr_name)
 				fprintf(fp, "\t%s = %u\n",
-					dvb_v5_name[entry->props[i].cmd],
+					dvb_cmd_name(entry->props[i].cmd),
 					entry->props[i].u.data);
 			else
 				fprintf(fp, "\t%s = %s\n",
-					dvb_v5_name[entry->props[i].cmd],
+					dvb_cmd_name(entry->props[i].cmd),
 					*attr_name);
 		}
 		fprintf(fp, "\n");
@@ -758,7 +758,7 @@ int write_dvb_file(const char *fname, struct dvb_file *dvb_file)
 	return 0;
 };
 
-char *dvb_vchannel(struct dvb_descriptors *dvb_desc,
+char *dvb_vchannel(struct dvb_v5_descriptors *dvb_desc,
 		   int service)
 {
 	struct service_table *service_table = &dvb_desc->sdt_table.service_table[service];
@@ -812,7 +812,7 @@ static int store_entry_prop(struct dvb_entry *entry,
 }
 
 static void handle_std_specific_parms(struct dvb_entry *entry,
-				      struct dvb_descriptors *dvb_desc)
+				      struct dvb_v5_descriptors *dvb_desc)
 {
 	struct nit_table *nit_table = &dvb_desc->nit_table;
 	int i;
@@ -933,7 +933,7 @@ static int sort_other_el_pid(const void *a_arg, const void *b_arg)
 
 int store_dvb_channel(struct dvb_file **dvb_file,
 		      struct dvb_v5_fe_parms *parms,
-		      struct dvb_descriptors *dvb_desc,
+		      struct dvb_v5_descriptors *dvb_desc,
 		      int get_detected, int get_nit)
 {
 	struct dvb_entry *entry;
diff --git a/lib/libdvbv5/dvb-log.c b/lib/libdvbv5/dvb-log.c
new file mode 100644
index 0000000..7fa811f
--- /dev/null
+++ b/lib/libdvbv5/dvb-log.c
@@ -0,0 +1,63 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "dvb-log.h"
+
+#include <stdio.h>
+#include <unistd.h>
+#include <stdarg.h>
+
+static const struct loglevel {
+	const char *name;
+	const char *color;
+	int fd;
+} loglevels[9] = {
+	{"EMERG   ", "\033[31m", STDERR_FILENO },
+	{"ALERT   ", "\033[31m", STDERR_FILENO },
+	{"CRITICAL", "\033[31m", STDERR_FILENO },
+	{"ERROR   ", "\033[31m", STDERR_FILENO },
+	{"WARNING ", "\033[33m", STDOUT_FILENO },
+	{"NOTICE  ", "\033[36m", STDOUT_FILENO },
+	{"INFO    ", "\033[36m", STDOUT_FILENO },
+	{"DEBUG   ", "\033[32m", STDOUT_FILENO },
+	{"",         "\033[0m",  STDOUT_FILENO },
+};
+#define LOG_COLOROFF 8
+
+void dvb_default_log(int level, const char *fmt, ...)
+{
+	if(level > sizeof(loglevels) / sizeof(struct loglevel) - 2) // ignore LOG_COLOROFF as well
+		level = LOG_INFO;
+	va_list ap;
+	va_start(ap, fmt);
+	FILE *out = stdout;
+	if(STDERR_FILENO == loglevels[level].fd)
+		out = stderr;
+	if(isatty(loglevels[level].fd))
+		fputs(loglevels[level].color, out);
+	fprintf(out, "%s ", loglevels[level].name);
+	vfprintf(out, fmt, ap);
+	fprintf(out, "\n");
+	if(isatty(loglevels[level].fd))
+		fputs(loglevels[LOG_COLOROFF].color, out);
+	va_end(ap);
+}
+
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index f591f8e..b9a0946 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -29,6 +29,7 @@
 #include "dvb-frontend.h"
 #include "descriptors.h"
 #include "parse_string.h"
+#include "crc32.h"
 
 #include <errno.h>
 #include <fcntl.h>
@@ -41,9 +42,9 @@
 #include <sys/types.h>
 #include <stdlib.h>
 
-static void parse_pat(struct dvb_descriptors *dvb_desc,
-		      const unsigned char *buf, int *section_length,
-		      int id, int version)
+static void parse_pat(struct dvb_v5_descriptors *dvb_desc,
+		const unsigned char *buf, int *section_length,
+		int id, int version)
 {
 	int service_id, pmt_pid;
 	int n;
@@ -53,15 +54,15 @@ static void parse_pat(struct dvb_descriptors *dvb_desc,
 
 	n = dvb_desc->pat_table.pid_table_len;
 	dvb_desc->pat_table.pid_table = realloc(dvb_desc->pat_table.pid_table,
-				sizeof(*dvb_desc->pat_table.pid_table) *
-				(n + (*section_length / 4)));
+			sizeof(*dvb_desc->pat_table.pid_table) *
+			(n + (*section_length / 4)));
 
 	while (*section_length > 3) {
 		service_id = (buf[0] << 8) | buf[1];
 		pmt_pid = ((buf[2] & 0x1f) << 8) | buf[3];
 
 		memset(&dvb_desc->pat_table.pid_table[n], 0,
-		       sizeof(dvb_desc->pat_table.pid_table[n]));
+				sizeof(dvb_desc->pat_table.pid_table[n]));
 
 		dvb_desc->pat_table.pid_table[n].service_id = service_id;
 		dvb_desc->pat_table.pid_table[n].pid = pmt_pid;
@@ -78,48 +79,42 @@ static void parse_pat(struct dvb_descriptors *dvb_desc,
 
 static void add_vpid(struct pid_table *pid_table, uint16_t pid, int verbose)
 {
-	int i;
-
 	if (verbose)
 		printf("video pid 0x%04x\n", pid);
-	i = pid_table->video_pid_len;
+	int i = pid_table->video_pid_len;
 	pid_table->video_pid = realloc(pid_table->video_pid,
-		sizeof(*pid_table->video_pid) * ++pid_table->video_pid_len);
+			sizeof(*pid_table->video_pid) * ++pid_table->video_pid_len);
 	pid_table->video_pid[i] = pid;
 }
 
 static void add_apid(struct pid_table *pid_table, uint16_t pid, int verbose)
 {
-	int i;
-
 	if (verbose)
 		printf("audio pid 0x%04x\n", pid);
-	i = pid_table->audio_pid_len;
+	int i = pid_table->audio_pid_len;
 	pid_table->audio_pid = realloc(pid_table->audio_pid,
-		sizeof(*pid_table->audio_pid) * ++pid_table->audio_pid_len);
+			sizeof(*pid_table->audio_pid) * ++pid_table->audio_pid_len);
 	pid_table->audio_pid[i] = pid;
 }
 
 static void add_otherpid(struct pid_table *pid_table,
-			 uint8_t type, uint16_t pid, int verbose)
+		uint8_t type, uint16_t pid, int verbose)
 {
-	int i;
-
 	if (verbose)
 		printf("pid type 0x%02x: 0x%04x\n", type, pid);
-	i = pid_table->other_el_pid_len;
+	int i = pid_table->other_el_pid_len;
 	pid_table->other_el_pid = realloc(pid_table->other_el_pid,
-		sizeof(*pid_table->other_el_pid) *
-		++pid_table->other_el_pid_len);
+			sizeof(*pid_table->other_el_pid) *
+			++pid_table->other_el_pid_len);
 
 	pid_table->other_el_pid[i].type = type;
 	pid_table->other_el_pid[i].pid = pid;
 }
 
-static void parse_pmt(struct dvb_descriptors *dvb_desc,
-		      const unsigned char *buf, int *section_length,
-		      int id, int version,
-		      struct pid_table *pid_table)
+static void parse_pmt(struct dvb_v5_descriptors *dvb_desc,
+		const unsigned char *buf, int *section_length,
+		int id, int version,
+		struct pid_table *pid_table)
 {
 	struct pmt_table *pmt_table = &pid_table->pmt_table;
 	uint16_t len, pid;
@@ -127,13 +122,13 @@ static void parse_pmt(struct dvb_descriptors *dvb_desc,
 	pmt_table->program_number = id;
 	pmt_table->version = version;
 
-        pmt_table->pcr_pid = ((buf[0] & 0x1f) << 8) | buf[1];
-        len = ((buf[2] & 0x0f) << 8) | buf[3];
+	pmt_table->pcr_pid = ((buf[0] & 0x1f) << 8) | buf[1];
+	len = ((buf[2] & 0x0f) << 8) | buf[3];
 
 	if (dvb_desc->verbose)
 		printf("PN 0x%04x, version %d, PCR ID 0x%04x, len %d\n",
-			pmt_table->program_number, pmt_table->version,
-			pmt_table->pcr_pid, len);
+				pmt_table->program_number, pmt_table->version,
+				pmt_table->pcr_pid, len);
 
 	parse_descriptor(PMT, dvb_desc, &buf[4], len);
 
@@ -145,36 +140,34 @@ static void parse_pmt(struct dvb_descriptors *dvb_desc,
 		pid = ((buf[1] & 0x1f) << 8) | buf[2];
 
 		switch (buf[0]) {
-		case 0x01: /* ISO/IEC 11172-2 Video */
-		case 0x02: /* H.262, ISO/IEC 13818-2 or ISO/IEC 11172-2 video */
-			add_vpid(pid_table, pid, dvb_desc->verbose);
-			break;
-		case 0x1b: /* H.264 AVC */
-			add_vpid(pid_table, pid, dvb_desc->verbose);
-			break;
-		case 0x03: /* ISO/IEC 11172-3 Audio */
-		case 0x04: /* ISO/IEC 13818-3 Audio */
-		case 0x0f: /* ISO/IEC 13818-7 Audio with ADTS (AAC) */
-		case 0x11: /* ISO/IEC 14496-3 Audio with the LATM */
-		case 0x81: /* user private - in general ATSC Dolby - AC-3 */
-			add_apid(pid_table, pid, dvb_desc->verbose);
-			break;
-		case 0x05: /* private sections */
-		case 0x06: /* private data */
-			/*
-			 * Those can be used by sub-titling, teletext and/or
-			 * DVB AC-3. So, need to seek for the AC-3 descriptors
-			 */
-			if (has_descriptor(dvb_desc, AC_3_descriptor, &buf[5], len) |
-			    has_descriptor(dvb_desc, enhanced_AC_3_descriptor, &buf[5], len))
+			case 0x01: /* ISO/IEC 11172-2 Video */
+			case 0x02: /* H.262, ISO/IEC 13818-2 or ISO/IEC 11172-2 video */
+			case 0x1b: /* H.264 AVC */
+				add_vpid(pid_table, pid, dvb_desc->verbose);
+				break;
+			case 0x03: /* ISO/IEC 11172-3 Audio */
+			case 0x04: /* ISO/IEC 13818-3 Audio */
+			case 0x0f: /* ISO/IEC 13818-7 Audio with ADTS (AAC) */
+			case 0x11: /* ISO/IEC 14496-3 Audio with the LATM */
+			case 0x81: /* user private - in general ATSC Dolby - AC-3 */
 				add_apid(pid_table, pid, dvb_desc->verbose);
-			else
-				add_otherpid(pid_table, buf[0], pid,
-					     dvb_desc->verbose);
-
-			break;
-		default:
-			add_otherpid(pid_table, buf[0], pid, dvb_desc->verbose);
+				break;
+			case 0x05: /* private sections */
+			case 0x06: /* private data */
+				/*
+				 * Those can be used by sub-titling, teletext and/or
+				 * DVB AC-3. So, need to seek for the AC-3 descriptors
+				 */
+				if (has_descriptor(dvb_desc, AC_3_descriptor, &buf[5], len) |
+						has_descriptor(dvb_desc, enhanced_AC_3_descriptor, &buf[5], len))
+					add_apid(pid_table, pid, dvb_desc->verbose);
+				else
+					add_otherpid(pid_table, buf[0], pid,
+							dvb_desc->verbose);
+				break;
+			default:
+				add_otherpid(pid_table, buf[0], pid, dvb_desc->verbose);
+				break;
 		};
 
 		parse_descriptor(PMT, dvb_desc, &buf[5], len);
@@ -184,9 +177,9 @@ static void parse_pmt(struct dvb_descriptors *dvb_desc,
 	};
 }
 
-static void parse_nit(struct dvb_descriptors *dvb_desc,
-		      const unsigned char *buf, int *section_length,
-		      int id, int version)
+static void parse_nit(struct dvb_v5_descriptors *dvb_desc,
+		const unsigned char *buf, int *section_length,
+		int id, int version)
 {
 	struct nit_table *nit_table = &dvb_desc->nit_table;
 	int len, n;
@@ -209,20 +202,20 @@ static void parse_nit(struct dvb_descriptors *dvb_desc,
 	n = nit_table->tr_table_len;
 	while (*section_length > 6) {
 		nit_table->tr_table = realloc(nit_table->tr_table,
-					sizeof(*nit_table->tr_table) * (n + 1));
+				sizeof(*nit_table->tr_table) * (n + 1));
 		memset(&nit_table->tr_table[n], 0,
-		       sizeof(nit_table->tr_table[n]));
+				sizeof(nit_table->tr_table[n]));
 		nit_table->tr_table[n].tr_id = (buf[0] << 8) | buf[1];
 
 		len = ((buf[4] & 0x0f) << 8) | buf[5];
 		if (*section_length < len + 4 && len > 0) {
 			fprintf(stderr, "NIT section too short for Network ID 0x%04x, transport stream ID 0x%04x",
-			       id, nit_table->tr_table[n].tr_id);
+					id, nit_table->tr_table[n].tr_id);
 			break;
 		} else if (len) {
 			if (dvb_desc->verbose)
 				printf("Transport stream #%d ID 0x%04x, len %d\n",
-					n, nit_table->tr_table[n].tr_id, len);
+						n, nit_table->tr_table[n].tr_id, len);
 
 			parse_descriptor(NIT, dvb_desc, &buf[6], len);
 		}
@@ -235,9 +228,9 @@ static void parse_nit(struct dvb_descriptors *dvb_desc,
 	nit_table->tr_table_len = n;
 }
 
-static void parse_sdt(struct dvb_descriptors *dvb_desc,
-		      const unsigned char *buf, int *section_length,
-		      int id, int version)
+static void parse_sdt(struct dvb_v5_descriptors *dvb_desc,
+		const unsigned char *buf, int *section_length,
+		int id, int version)
 {
 	struct sdt_table *sdt_table = &dvb_desc->sdt_table;
 	int len, n;
@@ -253,7 +246,7 @@ static void parse_sdt(struct dvb_descriptors *dvb_desc,
 		sdt_table->service_table = realloc(sdt_table->service_table,
 				sizeof(*sdt_table->service_table) * (n + 1));
 		memset(&sdt_table->service_table[n], 0,
-		       sizeof(sdt_table->service_table[n]));
+				sizeof(sdt_table->service_table[n]));
 		sdt_table->service_table[n].service_id = (buf[0] << 8) | buf[1];
 		len = ((buf[3] & 0x0f) << 8) | buf[4];
 		sdt_table->service_table[n].running = (buf[3] >> 5) & 0x7;
@@ -261,14 +254,14 @@ static void parse_sdt(struct dvb_descriptors *dvb_desc,
 
 		if (*section_length < len && len > 0) {
 			fprintf(stderr, "SDT section too short for Service ID 0x%04x\n",
-			       sdt_table->service_table[n].service_id);
+					sdt_table->service_table[n].service_id);
 		} else if (len) {
 			if (dvb_desc->verbose)
 				printf("Service #%d ID 0x%04x, running %d, scrambled %d\n",
-				n,
-				sdt_table->service_table[n].service_id,
-				sdt_table->service_table[n].running,
-				sdt_table->service_table[n].scrambled);
+						n,
+						sdt_table->service_table[n].service_id,
+						sdt_table->service_table[n].running,
+						sdt_table->service_table[n].scrambled);
 
 			parse_descriptor(SDT, dvb_desc, &buf[5], len);
 		}
@@ -316,13 +309,65 @@ static int poll(int filedes, unsigned int seconds)
 }
 
 
-static int read_section(int dmx_fd, struct dvb_descriptors *dvb_desc,
-			uint16_t pid, unsigned char table, void *ptr,
-			unsigned timeout)
+int dvb_read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char table, uint16_t pid, uint8_t **buf,
+		unsigned *length, unsigned timeout)
+{
+	int available;
+	ssize_t count = 0;
+	struct dmx_sct_filter_params f;
+	uint8_t *tmp;
+
+	// FIXME: verify known table
+	*buf = NULL;
+
+	memset(&f, 0, sizeof(f));
+	f.pid = pid;
+	f.filter.filter[0] = table;
+	f.filter.mask[0] = 0xff;
+	f.timeout = 0;
+	f.flags = DMX_IMMEDIATE_START | DMX_CHECK_CRC;
+	if (ioctl(dmx_fd, DMX_SET_FILTER, &f) == -1) {
+		perror("ioctl DMX_SET_FILTER failed");
+		return -1;
+	}
+
+	do {
+		available = poll(dmx_fd, timeout);
+		if (available > 0) {
+			tmp = malloc(DVB_MAX_PAYLOAD_PACKET_SIZE);
+			count = read(dmx_fd, tmp,
+					DVB_MAX_PAYLOAD_PACKET_SIZE);
+		}
+	} while (available < 0 && errno == EOVERFLOW);
+	if (!count) {
+		printf("no data read\n" );
+		return -1;
+	}
+	if (count < 0) {
+		perror("read_sections: read error");
+		return -2;
+	}
+
+	uint32_t crc = crc32(tmp, count, 0xFFFFFFFF);
+	if (crc != 0) {
+		printf("crc error\n");
+		return -3;
+	}
+
+	//ARRAY_SIZE(vb_table_initializers) >= table
+	*buf = dvb_table_initializers[table].init(parms, tmp, count);
+	if (length)
+		*length = count;
+	return 0;
+}
+
+static int read_section(int dmx_fd, struct dvb_v5_descriptors *dvb_desc,
+		uint16_t pid, unsigned char table, void *ptr,
+		unsigned timeout)
 {
-	int count;
+	ssize_t count;
 	int section_length, table_id, id, version, next = 0;
-	unsigned char buf[4096];
+	unsigned char buf[4096]; // FIXME: define
 	unsigned char *p;
 	struct dmx_sct_filter_params f;
 
@@ -368,7 +413,7 @@ static int read_section(int dmx_fd, struct dvb_descriptors *dvb_desc,
 
 		if (dvb_desc->verbose) {
 			printf("PID 0x%04x, TableID 0x%02x ID=0x%04x, version %d, ",
-			pid, table_id, id, version);
+					pid, table_id, id, version);
 			hexdump(buf, count);
 			printf("\tsection_length = %d ", section_length);
 			printf("section %d, last section %d\n", buf[6], buf[7]);
@@ -378,40 +423,40 @@ static int read_section(int dmx_fd, struct dvb_descriptors *dvb_desc,
 		section_length -= 8;
 
 		switch (table_id) {
-		case 0x00:	/* PAT */
-			parse_pat(dvb_desc, p, &section_length,
-					   id, version);
-			break;
-		case 0x02:	/* PMT */
-			parse_pmt(dvb_desc, p, &section_length,
-					   id, version, ptr);
-			break;
-		case 0x40:	/* NIT */
-		case 0x41:	/* NIT other */
-			parse_nit(dvb_desc, p, &section_length,
-					   id, version);
-			break;
-		case 0x42:	/* SAT */
-		case 0x46:	/* SAT other */
-			parse_sdt(dvb_desc, p, &section_length,
-					   id, version);
-			break;
+			case 0x00:	/* PAT */
+				parse_pat(dvb_desc, p, &section_length,
+						id, version);
+				break;
+			case 0x02:	/* PMT */
+				parse_pmt(dvb_desc, p, &section_length,
+						id, version, ptr);
+				break;
+			case 0x40:	/* NIT */
+			case 0x41:	/* NIT other */
+				parse_nit(dvb_desc, p, &section_length,
+						id, version);
+				break;
+			case 0x42:	/* SAT */
+			case 0x46:	/* SAT other */
+				parse_sdt(dvb_desc, p, &section_length,
+						id, version);
+				break;
 		}
 	} while (next);
 
 	return 0;
 }
 
-struct dvb_descriptors *dvb_get_ts_tables(int dmx_fd,
-					  uint32_t delivery_system,
-					  unsigned other_nit,
-					  unsigned timeout_multiply,
-					  int verbose)
+struct dvb_v5_descriptors *dvb_get_ts_tables(int dmx_fd,
+		uint32_t delivery_system,
+		unsigned other_nit,
+		unsigned timeout_multiply,
+		int verbose)
 {
 	int i, rc;
 	int pat_pmt_time, sdt_time, nit_time;
 
-	struct dvb_descriptors *dvb_desc;
+	struct dvb_v5_descriptors *dvb_desc;
 
 	dvb_desc = calloc(sizeof(*dvb_desc), 1);
 	if (!dvb_desc)
@@ -425,41 +470,42 @@ struct dvb_descriptors *dvb_get_ts_tables(int dmx_fd,
 
 	/* Get standard timeouts for each table */
 	switch(delivery_system) {
-	case SYS_DVBC_ANNEX_A:
-	case SYS_DVBC_ANNEX_C:
-	case SYS_DVBS:
-	case SYS_DVBS2:
-	case SYS_TURBO:
-		pat_pmt_time = 1;
-		sdt_time = 2;
-		nit_time = 10;
-		break;
-	case SYS_DVBT:
-	case SYS_DVBT2:
-		pat_pmt_time = 1;
-		sdt_time = 2;
-		nit_time = 12;
-		break;
-	case SYS_ISDBT:
-		pat_pmt_time = 1;
-		sdt_time = 2;
-		nit_time = 12;
-		break;
-	case SYS_ATSC:
-	case SYS_DVBC_ANNEX_B:
-		pat_pmt_time = 1;
-		sdt_time = 5;
-		nit_time = 5;
-	default:
-		pat_pmt_time = 1;
-		sdt_time = 2;
-		nit_time = 10;
-		break;
+		case SYS_DVBC_ANNEX_A:
+		case SYS_DVBC_ANNEX_C:
+		case SYS_DVBS:
+		case SYS_DVBS2:
+		case SYS_TURBO:
+			pat_pmt_time = 1;
+			sdt_time = 2;
+			nit_time = 10;
+			break;
+		case SYS_DVBT:
+		case SYS_DVBT2:
+			pat_pmt_time = 1;
+			sdt_time = 2;
+			nit_time = 12;
+			break;
+		case SYS_ISDBT:
+			pat_pmt_time = 1;
+			sdt_time = 2;
+			nit_time = 12;
+			break;
+		case SYS_ATSC:
+		case SYS_DVBC_ANNEX_B:
+			pat_pmt_time = 1;
+			sdt_time = 5;
+			nit_time = 5;
+			break;
+		default:
+			pat_pmt_time = 1;
+			sdt_time = 2;
+			nit_time = 10;
+			break;
 	};
 
 	/* PAT table */
 	rc = read_section(dmx_fd, dvb_desc, 0, 0, NULL,
-			  pat_pmt_time * timeout_multiply);
+			pat_pmt_time * timeout_multiply);
 	if (rc < 0) {
 		fprintf(stderr, "error while waiting for PAT table\n");
 		dvb_free_ts_tables(dvb_desc);
@@ -474,21 +520,21 @@ struct dvb_descriptors *dvb_get_ts_tables(int dmx_fd,
 		if (!pn)
 			continue;
 		rc = read_section(dmx_fd, dvb_desc, pid_table->pid, 0x02,
-			          pid_table, pat_pmt_time * timeout_multiply);
+				pid_table, pat_pmt_time * timeout_multiply);
 		if (rc < 0)
 			fprintf(stderr, "error while reading the PMT table for service 0x%04x\n",
-				pn);
+					pn);
 	}
 
 	/* NIT table */
 	rc = read_section(dmx_fd, dvb_desc, 0x0010, 0x40, NULL,
-		          nit_time * timeout_multiply);
+			nit_time * timeout_multiply);
 	if (rc < 0)
 		fprintf(stderr, "error while reading the NIT table\n");
 
 	/* SDT table */
 	rc = read_section(dmx_fd, dvb_desc, 0x0011, 0x42, NULL,
-		          sdt_time * timeout_multiply);
+			sdt_time * timeout_multiply);
 	if (rc < 0)
 		fprintf(stderr, "error while reading the SDT table\n");
 
@@ -497,16 +543,16 @@ struct dvb_descriptors *dvb_get_ts_tables(int dmx_fd,
 		if (verbose)
 			printf("Parsing other NIT/SDT\n");
 		rc = read_section(dmx_fd, dvb_desc, 0x0010, 0x41, NULL,
-			          nit_time * timeout_multiply);
+				nit_time * timeout_multiply);
 		rc = read_section(dmx_fd, dvb_desc, 0x0011, 0x46, NULL,
-			          sdt_time * timeout_multiply);
+				sdt_time * timeout_multiply);
 	}
 
 	return dvb_desc;
 }
 
 
-void dvb_free_ts_tables(struct dvb_descriptors *dvb_desc)
+void dvb_free_ts_tables(struct dvb_v5_descriptors *dvb_desc)
 {
 	struct pat_table *pat_table = &dvb_desc->pat_table;
 	struct pid_table *pid_table = dvb_desc->pat_table.pid_table;
diff --git a/utils/dvb/dvb-fe-tool.c b/utils/dvb/dvb-fe-tool.c
index 0292199..4c88afd 100644
--- a/utils/dvb/dvb-fe-tool.c
+++ b/utils/dvb/dvb-fe-tool.c
@@ -113,7 +113,7 @@ int main(int argc, char *argv[])
 #endif
 	if (get) {
 		dvb_fe_get_parms(parms);
-		dvb_fe_prt_parms(stdout, parms);
+		dvb_fe_prt_parms(parms);
 	}
 
 	dvb_fe_close(parms);
diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index 7ab5edd..33032a9 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -263,7 +263,7 @@ static int estimate_freq_shift(struct dvb_v5_fe_parms *parms)
 
 static void add_other_freq_entries(struct dvb_file *dvb_file,
 				   struct dvb_v5_fe_parms *parms,
-				   struct dvb_descriptors *dvb_desc)
+				   struct dvb_v5_descriptors *dvb_desc)
 {
 	int i;
 	uint32_t freq, shift = 0;
@@ -326,7 +326,7 @@ static int run_scan(struct arguments *args,
 	}
 
 	for (entry = dvb_file->first_entry; entry != NULL; entry = entry->next) {
-		struct dvb_descriptors *dvb_desc = NULL;
+		struct dvb_v5_descriptors *dvb_desc = NULL;
 
 		/* First of all, set the delivery system */
 		for (i = 0; i < entry->n_props; i++)
@@ -404,9 +404,9 @@ static int run_scan(struct arguments *args,
 
 		dvb_fe_retrieve_parm(parms, DTV_FREQUENCY, &freq);
 		count++;
-		printf("Scanning frequency #%d %d\n", count, freq);
+		dvb_log("Scanning frequency #%d %d", count, freq);
 		if (verbose)
-			dvb_fe_prt_parms(stdout, parms);
+			dvb_fe_prt_parms(parms);
 
 		rc = check_frontend(parms, 4);
 		if (rc < 0)
diff --git a/utils/v4l2-compliance/v4l2-test-formats.cpp b/utils/v4l2-compliance/v4l2-test-formats.cpp
index c86c697..2f0269e 100644
--- a/utils/v4l2-compliance/v4l2-test-formats.cpp
+++ b/utils/v4l2-compliance/v4l2-test-formats.cpp
@@ -108,7 +108,7 @@ static int testEnumFrameIntervals(struct node *node, __u32 pixfmt, __u32 w, __u3
 		default:
 			return fail("frmival.type is invalid\n");
 		}
-		
+
 		f++;
 	}
 	if (!valid)
@@ -194,7 +194,7 @@ static int testEnumFrameSizes(struct node *node, __u32 pixfmt)
 		default:
 			return fail("frmsize.type is invalid\n");
 		}
-		
+
 		f++;
 	}
 	info("found %d framesizes for pixel format %08x\n", f, pixfmt);
@@ -295,7 +295,7 @@ int testEnumFormats(struct node *node)
 		supported = true;
 		warn("Buffer type PRIVATE allowed!\n");
 	}
-		
+
 	ret = testEnumFrameSizes(node, 0x20202020);
 	if (ret != ENOTTY)
 		return fail("Accepted framesize for invalid format\n");
@@ -364,7 +364,7 @@ static int testFormatsType(struct node *node, unsigned type)
 	__u32 service_set = 0;
 	unsigned cnt = 0;
 	int ret;
-	
+
 	memset(&fmt, 0xff, sizeof(fmt));
 	fmt.type = type;
 	ret = doioctl(node, VIDIOC_G_FMT, &fmt);
@@ -375,7 +375,7 @@ static int testFormatsType(struct node *node, unsigned type)
 	if (ret)
 		return fail("expected EINVAL, but got %d when getting format for buftype %d\n", ret, type);
 	fail_on_test(fmt.type != type);
-	
+
 	switch (type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-- 
1.7.2.5

