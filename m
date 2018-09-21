Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20189 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728184AbeIUU7k (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 16:59:40 -0400
From: Ville Syrjala <ville.syrjala@linux.intel.com>
To: dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: [PATCH v2 07/18] video/hdmi: Handle the NTSC VBI infoframe
Date: Fri, 21 Sep 2018 18:10:17 +0300
Message-Id: <20180921151017.13133-1-ville.syrjala@linux.intel.com>
In-Reply-To: <20180920185145.1912-8-ville.syrjala@linux.intel.com>
References: <20180920185145.1912-8-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Add the code to deal with the NTSC VBI infoframe.

I decided against parsing the PES_data_field and just leave
it as an opaque blob, just dumping it out as hex in the log.

Blindly typed from the spec, and totally untested.

v2: Rebase

Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/video/hdmi.c | 208 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/hdmi.h |  18 +++++
 2 files changed, 226 insertions(+)

diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
index 6f39b9ae56b9..b14202fc5854 100644
--- a/drivers/video/hdmi.c
+++ b/drivers/video/hdmi.c
@@ -831,6 +831,139 @@ ssize_t hdmi_mpeg_source_infoframe_pack(struct hdmi_mpeg_source_infoframe *frame
 }
 EXPORT_SYMBOL(hdmi_mpeg_source_infoframe_pack);
 
+/**
+ * hdmi_ntsc_vbi_infoframe_init() - initialize an HDMI NTSC VBI infoframe
+ * @frame: HDMI NTSC VBI infoframe
+ * @pes_data_field: ANSI/SCTE 127 PES_data_field
+ * @length: ANSI/SCTE 127 PES_data_field length
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+int hdmi_ntsc_vbi_infoframe_init(struct hdmi_ntsc_vbi_infoframe *frame,
+				 const void *pes_data_field,
+				 size_t length)
+{
+	if (length < 1 || length > 27)
+		return -EINVAL;
+
+	memset(frame, 0, sizeof(*frame));
+
+	frame->type = HDMI_INFOFRAME_TYPE_NTSC_VBI;
+	frame->version = 1;
+	frame->length = length;
+
+	memcpy(frame->pes_data_field, pes_data_field, length);
+
+	return 0;
+}
+EXPORT_SYMBOL(hdmi_ntsc_vbi_infoframe_init);
+
+static int hdmi_ntsc_vbi_infoframe_check_only(const struct hdmi_ntsc_vbi_infoframe *frame)
+{
+	if (frame->type != HDMI_INFOFRAME_TYPE_NTSC_VBI ||
+	    frame->version != 1 ||
+	    frame->length < 1 || frame->length > 27)
+		return -EINVAL;
+
+	if (frame->pes_data_field[0] != 0x99)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * hdmi_ntsc_vbi_infoframe_check() - Check and check a HDMI NTSC VBI infoframe
+ * @frame: HDMI NTSC VBI infoframe
+ *
+ * Validates that the infoframe is consistent and updates derived fields
+ * (eg. length) based on other fields.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+int hdmi_ntsc_vbi_infoframe_check(struct hdmi_ntsc_vbi_infoframe *frame)
+{
+	return hdmi_ntsc_vbi_infoframe_check_only(frame);
+}
+EXPORT_SYMBOL(hdmi_ntsc_vbi_infoframe_check);
+
+/**
+ * hdmi_ntsc_vbi_infoframe_pack_only() - write HDMI NTSC VBI infoframe to binary buffer
+ * @frame: HDMI NTSC VBI infoframe
+ * @buffer: destination buffer
+ * @size: size of buffer
+ *
+ * Packs the information contained in the @frame structure into a binary
+ * representation that can be written into the corresponding controller
+ * registers. Also computes the checksum as required by section 5.3.5 of
+ * the HDMI 1.4 specification.
+ *
+ * Returns the number of bytes packed into the binary buffer or a negative
+ * error code on failure.
+ */
+ssize_t hdmi_ntsc_vbi_infoframe_pack_only(const struct hdmi_ntsc_vbi_infoframe *frame,
+					  void *buffer, size_t size)
+{
+	u8 *ptr = buffer;
+	size_t length;
+	int ret;
+
+	ret = hdmi_ntsc_vbi_infoframe_check_only(frame);
+	if (ret)
+		return ret;
+
+	length = HDMI_INFOFRAME_HEADER_SIZE + frame->length;
+
+	if (size < length)
+		return -ENOSPC;
+
+	memset(buffer, 0, size);
+
+	ptr[0] = frame->type;
+	ptr[1] = frame->version;
+	ptr[2] = frame->length;
+	ptr[3] = 0; /* checksum */
+
+	/* start infoframe payload */
+	ptr += HDMI_INFOFRAME_HEADER_SIZE;
+
+	memcpy(ptr, frame->pes_data_field, frame->length);
+
+	hdmi_infoframe_set_checksum(buffer, length);
+
+	return length;
+}
+EXPORT_SYMBOL(hdmi_ntsc_vbi_infoframe_pack_only);
+
+/**
+ * hdmi_ntsc_vbi_infoframe_pack() - check a HDMI NTSC VBI infoframe,
+ *                                  and write it to binary buffer
+ * @frame: HDMI NTSC VBI infoframe
+ * @buffer: destination buffer
+ * @size: size of buffer
+ *
+ * Validates that the infoframe is consistent and updates derived fields
+ * (eg. length) based on other fields, after which packs the information
+ * contained in the @frame structure into a binary representation that
+ * can be written into the corresponding controller registers. This function
+ * also computes the checksum as required by section 5.3.5 of the HDMI 1.4
+ * specification.
+ *
+ * Returns the number of bytes packed into the binary buffer or a negative
+ * error code on failure.
+ */
+ssize_t hdmi_ntsc_vbi_infoframe_pack(struct hdmi_ntsc_vbi_infoframe *frame,
+				     void *buffer, size_t size)
+{
+	int ret;
+
+	ret = hdmi_ntsc_vbi_infoframe_check(frame);
+	if (ret)
+		return ret;
+
+	return hdmi_ntsc_vbi_infoframe_pack_only(frame, buffer, size);
+}
+EXPORT_SYMBOL(hdmi_ntsc_vbi_infoframe_pack);
+
 /**
  * hdmi_infoframe_check() - check a HDMI infoframe
  * @frame: HDMI infoframe
@@ -854,6 +987,8 @@ hdmi_infoframe_check(union hdmi_infoframe *frame)
 		return hdmi_vendor_any_infoframe_check(&frame->vendor);
 	case HDMI_INFOFRAME_TYPE_MPEG_SOURCE:
 		return hdmi_mpeg_source_infoframe_check(&frame->mpeg_source);
+	case HDMI_INFOFRAME_TYPE_NTSC_VBI:
+		return hdmi_ntsc_vbi_infoframe_check(&frame->ntsc_vbi);
 	default:
 		WARN(1, "Bad infoframe type %d\n", frame->any.type);
 		return -EINVAL;
@@ -901,6 +1036,10 @@ hdmi_infoframe_pack_only(const union hdmi_infoframe *frame, void *buffer, size_t
 		length = hdmi_mpeg_source_infoframe_pack_only(&frame->mpeg_source,
 							      buffer, size);
 		break;
+	case HDMI_INFOFRAME_TYPE_NTSC_VBI:
+		length = hdmi_ntsc_vbi_infoframe_pack_only(&frame->ntsc_vbi,
+							   buffer, size);
+		break;
 	default:
 		WARN(1, "Bad infoframe type %d\n", frame->any.type);
 		length = -EINVAL;
@@ -951,6 +1090,10 @@ hdmi_infoframe_pack(union hdmi_infoframe *frame,
 		length = hdmi_mpeg_source_infoframe_pack(&frame->mpeg_source,
 							 buffer, size);
 		break;
+	case HDMI_INFOFRAME_TYPE_NTSC_VBI:
+		length = hdmi_ntsc_vbi_infoframe_pack(&frame->ntsc_vbi,
+						      buffer, size);
+		break;
 	default:
 		WARN(1, "Bad infoframe type %d\n", frame->any.type);
 		length = -EINVAL;
@@ -975,6 +1118,8 @@ static const char *hdmi_infoframe_type_get_name(enum hdmi_infoframe_type type)
 		return "Audio";
 	case HDMI_INFOFRAME_TYPE_MPEG_SOURCE:
 		return "MPEG Source";
+	case HDMI_INFOFRAME_TYPE_NTSC_VBI:
+		return "NTSC VBI";
 	}
 	return "Reserved";
 }
@@ -1526,6 +1671,22 @@ static void hdmi_mpeg_source_infoframe_log(const char *level,
 		 frame->field_repeat ? "Yes" : "No");
 }
 
+/**
+ * hdmi_ntsc_vbi_infoframe_log() - log info of HDMI NTSC VBI infoframe
+ * @level: logging level
+ * @dev: device
+ * @frame: HDMI NTSC VBI infoframe
+ */
+static void hdmi_ntsc_vbi_infoframe_log(const char *level,
+					struct device *dev,
+					const struct hdmi_ntsc_vbi_infoframe *frame)
+{
+	hdmi_infoframe_log_header(level, dev,
+				  (const struct hdmi_any_infoframe *)frame);
+
+	hdmi_log("    %*ph\n", frame->length, frame->pes_data_field);
+}
+
 /**
  * hdmi_infoframe_log() - log info of HDMI infoframe
  * @level: logging level
@@ -1552,6 +1713,9 @@ void hdmi_infoframe_log(const char *level,
 	case HDMI_INFOFRAME_TYPE_MPEG_SOURCE:
 		hdmi_mpeg_source_infoframe_log(level, dev, &frame->mpeg_source);
 		break;
+	case HDMI_INFOFRAME_TYPE_NTSC_VBI:
+		hdmi_ntsc_vbi_infoframe_log(level, dev, &frame->ntsc_vbi);
+		break;
 	}
 }
 EXPORT_SYMBOL(hdmi_infoframe_log);
@@ -1840,6 +2004,47 @@ static int hdmi_mpeg_source_infoframe_unpack(struct hdmi_mpeg_source_infoframe *
 	return 0;
 }
 
+/**
+ * hdmi_ntsc_vbi_infoframe_unpack() - unpack binary buffer to a HDMI MPEG Source infoframe
+ * @frame: HDMI MPEG Source infoframe
+ * @buffer: source buffer
+ * @size: size of buffer
+ *
+ * Unpacks the information contained in binary @buffer into a structured
+ * @frame of the HDMI MPEG Source information frame.
+ * Also verifies the checksum as required by section 5.3.5 of the HDMI 1.4
+ * specification.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+static int hdmi_ntsc_vbi_infoframe_unpack(struct hdmi_ntsc_vbi_infoframe *frame,
+					  const void *buffer, size_t size)
+{
+	const u8 *ptr = buffer;
+	size_t length;
+
+	if (size < HDMI_INFOFRAME_HEADER_SIZE)
+		return -EINVAL;
+
+	if (ptr[0] != HDMI_INFOFRAME_TYPE_NTSC_VBI ||
+	    ptr[1] != 1 ||
+	    ptr[2] < 1 || ptr[2] > 27)
+		return -EINVAL;
+
+	length = ptr[2];
+
+	if (size < HDMI_INFOFRAME_HEADER_SIZE + length)
+		return -EINVAL;
+
+	if (hdmi_infoframe_checksum(buffer,
+				    HDMI_INFOFRAME_HEADER_SIZE + length) != 0)
+		return -EINVAL;
+
+	ptr += HDMI_INFOFRAME_HEADER_SIZE;
+
+	return hdmi_ntsc_vbi_infoframe_init(frame, ptr, length);
+}
+
 /**
  * hdmi_infoframe_unpack() - unpack binary buffer to a HDMI infoframe
  * @frame: HDMI infoframe
@@ -1878,6 +2083,9 @@ int hdmi_infoframe_unpack(union hdmi_infoframe *frame,
 	case HDMI_INFOFRAME_TYPE_MPEG_SOURCE:
 		ret = hdmi_mpeg_source_infoframe_unpack(&frame->mpeg_source, buffer, size);
 		break;
+	case HDMI_INFOFRAME_TYPE_NTSC_VBI:
+		ret = hdmi_ntsc_vbi_infoframe_unpack(&frame->ntsc_vbi, buffer, size);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
index 2c9322f7538d..3821516b336c 100644
--- a/include/linux/hdmi.h
+++ b/include/linux/hdmi.h
@@ -48,6 +48,7 @@ enum hdmi_infoframe_type {
 	HDMI_INFOFRAME_TYPE_SPD = 0x83,
 	HDMI_INFOFRAME_TYPE_AUDIO = 0x84,
 	HDMI_INFOFRAME_TYPE_MPEG_SOURCE = 0x85,
+	HDMI_INFOFRAME_TYPE_NTSC_VBI = 0x86,
 };
 
 #define HDMI_IEEE_OUI 0x000c03
@@ -362,6 +363,21 @@ ssize_t hdmi_mpeg_source_infoframe_pack_only(const struct hdmi_mpeg_source_infof
 					     void *buffer, size_t size);
 int hdmi_mpeg_source_infoframe_check(struct hdmi_mpeg_source_infoframe *frame);
 
+struct hdmi_ntsc_vbi_infoframe {
+	enum hdmi_infoframe_type type;
+	unsigned char version;
+	unsigned char length;
+	unsigned char pes_data_field[27];
+};
+
+int hdmi_ntsc_vbi_infoframe_init(struct hdmi_ntsc_vbi_infoframe *frame,
+				 const void *pes_data_field, size_t length);
+ssize_t hdmi_ntsc_vbi_infoframe_pack(struct hdmi_ntsc_vbi_infoframe *frame,
+				     void *buffer, size_t size);
+ssize_t hdmi_ntsc_vbi_infoframe_pack_only(const struct hdmi_ntsc_vbi_infoframe *frame,
+					  void *buffer, size_t size);
+int hdmi_ntsc_vbi_infoframe_check(struct hdmi_ntsc_vbi_infoframe *frame);
+
 /**
  * union hdmi_infoframe - overall union of all abstract infoframe representations
  * @any: generic infoframe
@@ -370,6 +386,7 @@ int hdmi_mpeg_source_infoframe_check(struct hdmi_mpeg_source_infoframe *frame);
  * @vendor: union of all vendor infoframes
  * @audio: audio infoframe
  * @mpeg_source: mpeg source infoframe
+ * @ntsc_vbi: ntsc vbi infoframe
  *
  * This is used by the generic pack function. This works since all infoframes
  * have the same header which also indicates which type of infoframe should be
@@ -382,6 +399,7 @@ union hdmi_infoframe {
 	union hdmi_vendor_any_infoframe vendor;
 	struct hdmi_audio_infoframe audio;
 	struct hdmi_mpeg_source_infoframe mpeg_source;
+	struct hdmi_ntsc_vbi_infoframe ntsc_vbi;
 };
 
 ssize_t hdmi_infoframe_pack(union hdmi_infoframe *frame, void *buffer,
-- 
2.16.4
