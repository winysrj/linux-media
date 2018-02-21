Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:38455 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966051AbeBUPc0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 10:32:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 15/15] media.h: reorganize header to make it easier to understand
Date: Wed, 21 Feb 2018 16:32:18 +0100
Message-Id: <20180221153218.15654-16-hverkuil@xs4all.nl>
In-Reply-To: <20180221153218.15654-1-hverkuil@xs4all.nl>
References: <20180221153218.15654-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media.h public header is very messy. It mixes legacy and 'new' defines
and it is not easy to figure out what should and what shouldn't be used. It
also contains confusing comment that are either out of date or completely
uninteresting for anyone that needs to use this header.

The patch groups all entity functions together, including the 'old' defines
based on the old range base. The reader just wants to know about the available
functions and doesn't care about what range is used.

All legacy defines are moved to the end of the header, so it is easier to
locate them and just ignore them.

The legacy structs in the struct media_entity_desc are put under
also a much more effective signal to the reader that they shouldn't be used
compared to the old method of relying on '#if 1' followed by a comment.

The unused MEDIA_INTF_T_ALSA_* defines are also moved to the end of the header
in the legacy area. They are also dropped from intf_type() in media-entity.c.

All defines are also aligned at the same tab making the header easier to read.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c |  16 --
 include/uapi/linux/media.h   | 345 +++++++++++++++++++++----------------------
 2 files changed, 166 insertions(+), 195 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index f7c6d64e6031..3498551e618e 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -64,22 +64,6 @@ static inline const char *intf_type(struct media_interface *intf)
 		return "v4l-swradio";
 	case MEDIA_INTF_T_V4L_TOUCH:
 		return "v4l-touch";
-	case MEDIA_INTF_T_ALSA_PCM_CAPTURE:
-		return "alsa-pcm-capture";
-	case MEDIA_INTF_T_ALSA_PCM_PLAYBACK:
-		return "alsa-pcm-playback";
-	case MEDIA_INTF_T_ALSA_CONTROL:
-		return "alsa-control";
-	case MEDIA_INTF_T_ALSA_COMPRESS:
-		return "alsa-compress";
-	case MEDIA_INTF_T_ALSA_RAWMIDI:
-		return "alsa-rawmidi";
-	case MEDIA_INTF_T_ALSA_HWDEP:
-		return "alsa-hwdep";
-	case MEDIA_INTF_T_ALSA_SEQUENCER:
-		return "alsa-sequencer";
-	case MEDIA_INTF_T_ALSA_TIMER:
-		return "alsa-timer";
 	default:
 		return "unknown-intf";
 	}
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 573da38a21c3..b5043ee59108 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -15,10 +15,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifndef __LINUX_MEDIA_H
@@ -42,108 +38,65 @@ struct media_device_info {
 	__u32 reserved[31];
 };
 
-#define MEDIA_ENT_ID_FLAG_NEXT		(1 << 31)
-
-/*
- * Initial value to be used when a new entity is created
- * Drivers should change it to something useful
- */
-#define MEDIA_ENT_F_UNKNOWN	0x00000000
-
 /*
  * Base number ranges for entity functions
  *
- * NOTE: those ranges and entity function number are phased just to
- * make it easier to maintain this file. Userspace should not rely on
- * the ranges to identify a group of function types, as newer
- * functions can be added with any name within the full u32 range.
+ * NOTE: Userspace should not rely on these ranges to identify a group
+ * of function types, as newer functions can be added with any name within
+ * the full u32 range.
+ *
+ * Some older functions use the MEDIA_ENT_F_OLD_*_BASE range. Do not
+ * changes this, this is for backwards compatibility. When adding new
+ * functions always use MEDIA_ENT_F_BASE.
  */
-#define MEDIA_ENT_F_BASE		0x00000000
-#define MEDIA_ENT_F_OLD_BASE		0x00010000
-#define MEDIA_ENT_F_OLD_SUBDEV_BASE	0x00020000
+#define MEDIA_ENT_F_BASE			0x00000000
+#define MEDIA_ENT_F_OLD_BASE			0x00010000
+#define MEDIA_ENT_F_OLD_SUBDEV_BASE		0x00020000
 
 /*
- * DVB entities
+ * Initial value to be used when a new entity is created
+ * Drivers should change it to something useful.
  */
-#define MEDIA_ENT_F_DTV_DEMOD		(MEDIA_ENT_F_BASE + 0x00001)
-#define MEDIA_ENT_F_TS_DEMUX		(MEDIA_ENT_F_BASE + 0x00002)
-#define MEDIA_ENT_F_DTV_CA		(MEDIA_ENT_F_BASE + 0x00003)
-#define MEDIA_ENT_F_DTV_NET_DECAP	(MEDIA_ENT_F_BASE + 0x00004)
+#define MEDIA_ENT_F_UNKNOWN			MEDIA_ENT_F_BASE
 
 /*
- * I/O entities
+ * Subdevs are initialized with MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN in order
+ * to preserve backward compatibility. Drivers must change to the proper
+ * subdev function before registering the entity.
  */
-#define MEDIA_ENT_F_IO_DTV		(MEDIA_ENT_F_BASE + 0x01001)
-#define MEDIA_ENT_F_IO_VBI		(MEDIA_ENT_F_BASE + 0x01002)
-#define MEDIA_ENT_F_IO_SWRADIO		(MEDIA_ENT_F_BASE + 0x01003)
+#define MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN		MEDIA_ENT_F_OLD_SUBDEV_BASE
 
 /*
- * Analog TV IF-PLL decoders
- *
- * It is a responsibility of the master/bridge drivers to create links
- * for MEDIA_ENT_F_IF_VID_DECODER and MEDIA_ENT_F_IF_AUD_DECODER.
+ * DVB entity functions
  */
-#define MEDIA_ENT_F_IF_VID_DECODER	(MEDIA_ENT_F_BASE + 0x02001)
-#define MEDIA_ENT_F_IF_AUD_DECODER	(MEDIA_ENT_F_BASE + 0x02002)
+#define MEDIA_ENT_F_DTV_DEMOD			(MEDIA_ENT_F_BASE + 0x00001)
+#define MEDIA_ENT_F_TS_DEMUX			(MEDIA_ENT_F_BASE + 0x00002)
+#define MEDIA_ENT_F_DTV_CA			(MEDIA_ENT_F_BASE + 0x00003)
+#define MEDIA_ENT_F_DTV_NET_DECAP		(MEDIA_ENT_F_BASE + 0x00004)
 
 /*
- * Audio Entity Functions
+ * I/O entity functions
  */
-#define MEDIA_ENT_F_AUDIO_CAPTURE	(MEDIA_ENT_F_BASE + 0x03001)
-#define MEDIA_ENT_F_AUDIO_PLAYBACK	(MEDIA_ENT_F_BASE + 0x03002)
-#define MEDIA_ENT_F_AUDIO_MIXER		(MEDIA_ENT_F_BASE + 0x03003)
+#define MEDIA_ENT_F_IO_V4L  			(MEDIA_ENT_F_OLD_BASE + 1)
+#define MEDIA_ENT_F_IO_DTV			(MEDIA_ENT_F_BASE + 0x01001)
+#define MEDIA_ENT_F_IO_VBI			(MEDIA_ENT_F_BASE + 0x01002)
+#define MEDIA_ENT_F_IO_SWRADIO			(MEDIA_ENT_F_BASE + 0x01003)
 
 /*
- * Processing entities
+ * Sensor functions
  */
-#define MEDIA_ENT_F_PROC_VIDEO_COMPOSER		(MEDIA_ENT_F_BASE + 0x4001)
-#define MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER	(MEDIA_ENT_F_BASE + 0x4002)
-#define MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV	(MEDIA_ENT_F_BASE + 0x4003)
-#define MEDIA_ENT_F_PROC_VIDEO_LUT		(MEDIA_ENT_F_BASE + 0x4004)
-#define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 0x4005)
-#define MEDIA_ENT_F_PROC_VIDEO_STATISTICS	(MEDIA_ENT_F_BASE + 0x4006)
+#define MEDIA_ENT_F_CAM_SENSOR			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 1)
+#define MEDIA_ENT_F_FLASH			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 2)
+#define MEDIA_ENT_F_LENS			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 3)
 
 /*
- * Switch and bridge entitites
+ * Analog video decoder functions
  */
-#define MEDIA_ENT_F_VID_MUX			(MEDIA_ENT_F_BASE + 0x5001)
-#define MEDIA_ENT_F_VID_IF_BRIDGE		(MEDIA_ENT_F_BASE + 0x5002)
+#define MEDIA_ENT_F_ATV_DECODER			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 4)
 
 /*
- * Connectors
- */
-/* It is a responsibility of the entity drivers to add connectors and links */
-#ifdef __KERNEL__
-	/*
-	 * For now, it should not be used in userspace, as some
-	 * definitions may change
-	 */
-
-#define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 0x30001)
-#define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 0x30002)
-#define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 0x30003)
-
-#endif
-
-/*
- * Don't touch on those. The ranges MEDIA_ENT_F_OLD_BASE and
- * MEDIA_ENT_F_OLD_SUBDEV_BASE are kept to keep backward compatibility
- * with the legacy v1 API.The number range is out of range by purpose:
- * several previously reserved numbers got excluded from this range.
+ * Digital TV, analog TV, radio and/or software defined radio tuner functions.
  *
- * Subdevs are initialized with MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN,
- * in order to preserve backward compatibility.
- * Drivers must change to the proper subdev type before
- * registering the entity.
- */
-
-#define MEDIA_ENT_F_IO_V4L  		(MEDIA_ENT_F_OLD_BASE + 1)
-
-#define MEDIA_ENT_F_CAM_SENSOR		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 1)
-#define MEDIA_ENT_F_FLASH		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 2)
-#define MEDIA_ENT_F_LENS		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 3)
-#define MEDIA_ENT_F_ATV_DECODER		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 4)
-/*
  * It is a responsibility of the master/bridge drivers to add connectors
  * and links for MEDIA_ENT_F_TUNER. Please notice that some old tuners
  * may require the usage of separate I2C chips to decode analog TV signals,
@@ -151,49 +104,46 @@ struct media_device_info {
  * On such cases, the IF-PLL staging is mapped via one or two entities:
  * MEDIA_ENT_F_IF_VID_DECODER and/or MEDIA_ENT_F_IF_AUD_DECODER.
  */
-#define MEDIA_ENT_F_TUNER		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 5)
+#define MEDIA_ENT_F_TUNER			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 5)
 
-#define MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN	MEDIA_ENT_F_OLD_SUBDEV_BASE
+/*
+ * Analog TV IF-PLL decoder functions
+ *
+ * It is a responsibility of the master/bridge drivers to create links
+ * for MEDIA_ENT_F_IF_VID_DECODER and MEDIA_ENT_F_IF_AUD_DECODER.
+ */
+#define MEDIA_ENT_F_IF_VID_DECODER		(MEDIA_ENT_F_BASE + 0x02001)
+#define MEDIA_ENT_F_IF_AUD_DECODER		(MEDIA_ENT_F_BASE + 0x02002)
 
-#if !defined(__KERNEL__) || defined(__NEED_MEDIA_LEGACY_API)
+/*
+ * Audio entity functions
+ */
+#define MEDIA_ENT_F_AUDIO_CAPTURE		(MEDIA_ENT_F_BASE + 0x03001)
+#define MEDIA_ENT_F_AUDIO_PLAYBACK		(MEDIA_ENT_F_BASE + 0x03002)
+#define MEDIA_ENT_F_AUDIO_MIXER			(MEDIA_ENT_F_BASE + 0x03003)
 
 /*
- * Legacy symbols used to avoid userspace compilation breakages
- *
- * Those symbols map the entity function into types and should be
- * used only on legacy programs for legacy hardware. Don't rely
- * on those for MEDIA_IOC_G_TOPOLOGY.
+ * Processing entity functions
  */
-#define MEDIA_ENT_TYPE_SHIFT		16
-#define MEDIA_ENT_TYPE_MASK		0x00ff0000
-#define MEDIA_ENT_SUBTYPE_MASK		0x0000ffff
-
-/* End of the old subdev reserved numberspace */
-#define MEDIA_ENT_T_DEVNODE_UNKNOWN	(MEDIA_ENT_T_DEVNODE | \
-					 MEDIA_ENT_SUBTYPE_MASK)
-
-#define MEDIA_ENT_T_DEVNODE		MEDIA_ENT_F_OLD_BASE
-#define MEDIA_ENT_T_DEVNODE_V4L		MEDIA_ENT_F_IO_V4L
-#define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
-#define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
-#define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
-
-#define MEDIA_ENT_T_UNKNOWN		MEDIA_ENT_F_UNKNOWN
-#define MEDIA_ENT_T_V4L2_VIDEO		MEDIA_ENT_F_IO_V4L
-#define MEDIA_ENT_T_V4L2_SUBDEV		MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN
-#define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	MEDIA_ENT_F_CAM_SENSOR
-#define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	MEDIA_ENT_F_FLASH
-#define MEDIA_ENT_T_V4L2_SUBDEV_LENS	MEDIA_ENT_F_LENS
-#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	MEDIA_ENT_F_ATV_DECODER
-#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	MEDIA_ENT_F_TUNER
+#define MEDIA_ENT_F_PROC_VIDEO_COMPOSER		(MEDIA_ENT_F_BASE + 0x4001)
+#define MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER	(MEDIA_ENT_F_BASE + 0x4002)
+#define MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV	(MEDIA_ENT_F_BASE + 0x4003)
+#define MEDIA_ENT_F_PROC_VIDEO_LUT		(MEDIA_ENT_F_BASE + 0x4004)
+#define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 0x4005)
+#define MEDIA_ENT_F_PROC_VIDEO_STATISTICS	(MEDIA_ENT_F_BASE + 0x4006)
 
-/* Obsolete symbol for media_version, no longer used in the kernel */
-#define MEDIA_API_VERSION		KERNEL_VERSION(0, 1, 0)
-#endif
+/*
+ * Switch and bridge entity functions
+ */
+#define MEDIA_ENT_F_VID_MUX			(MEDIA_ENT_F_BASE + 0x5001)
+#define MEDIA_ENT_F_VID_IF_BRIDGE		(MEDIA_ENT_F_BASE + 0x5002)
 
 /* Entity flags */
-#define MEDIA_ENT_FL_DEFAULT		(1 << 0)
-#define MEDIA_ENT_FL_CONNECTOR		(1 << 1)
+#define MEDIA_ENT_FL_DEFAULT			(1 << 0)
+#define MEDIA_ENT_FL_CONNECTOR			(1 << 1)
+
+/* Flags for struct media_entity_desc id field */
+#define MEDIA_ENT_ID_FLAG_NEXT			(1 << 31)
 
 struct media_entity_desc {
 	__u32 id;
@@ -214,7 +164,7 @@ struct media_entity_desc {
 			__u32 minor;
 		} dev;
 
-#if 1
+#if !defined(__KERNEL__)
 		/*
 		 * TODO: this shouldn't have been added without
 		 * actual drivers that use this. When the first real driver
@@ -225,24 +175,17 @@ struct media_entity_desc {
 		 * contain the subdevice information. In addition, struct dev
 		 * can only refer to a single device, and not to multiple (e.g.
 		 * pcm and mixer devices).
-		 *
-		 * So for now mark this as a to do.
 		 */
 		struct {
 			__u32 card;
 			__u32 device;
 			__u32 subdevice;
 		} alsa;
-#endif
 
-#if 1
 		/*
 		 * DEPRECATED: previous node specifications. Kept just to
-		 * avoid breaking compilation, but media_entity_desc.dev
-		 * should be used instead. In particular, alsa and dvb
-		 * fields below are wrong: for all devnodes, there should
-		 * be just major/minor inside the struct, as this is enough
-		 * to represent any devnode, no matter what type.
+		 * avoid breaking compilation. Use media_entity_desc.dev
+		 * instead.
 		 */
 		struct {
 			__u32 major;
@@ -261,9 +204,9 @@ struct media_entity_desc {
 	};
 };
 
-#define MEDIA_PAD_FL_SINK		(1 << 0)
-#define MEDIA_PAD_FL_SOURCE		(1 << 1)
-#define MEDIA_PAD_FL_MUST_CONNECT	(1 << 2)
+#define MEDIA_PAD_FL_SINK			(1 << 0)
+#define MEDIA_PAD_FL_SOURCE			(1 << 1)
+#define MEDIA_PAD_FL_MUST_CONNECT		(1 << 2)
 
 struct media_pad_desc {
 	__u32 entity;		/* entity ID */
@@ -272,13 +215,13 @@ struct media_pad_desc {
 	__u32 reserved[2];
 };
 
-#define MEDIA_LNK_FL_ENABLED		(1 << 0)
-#define MEDIA_LNK_FL_IMMUTABLE		(1 << 1)
-#define MEDIA_LNK_FL_DYNAMIC		(1 << 2)
+#define MEDIA_LNK_FL_ENABLED			(1 << 0)
+#define MEDIA_LNK_FL_IMMUTABLE			(1 << 1)
+#define MEDIA_LNK_FL_DYNAMIC			(1 << 2)
 
-#define MEDIA_LNK_FL_LINK_TYPE		(0xf << 28)
-#  define MEDIA_LNK_FL_DATA_LINK	(0 << 28)
-#  define MEDIA_LNK_FL_INTERFACE_LINK	(1 << 28)
+#define MEDIA_LNK_FL_LINK_TYPE			(0xf << 28)
+#  define MEDIA_LNK_FL_DATA_LINK		(0 << 28)
+#  define MEDIA_LNK_FL_INTERFACE_LINK		(1 << 28)
 
 struct media_link_desc {
 	struct media_pad_desc source;
@@ -298,57 +241,47 @@ struct media_links_enum {
 
 /* Interface type ranges */
 
-#define MEDIA_INTF_T_DVB_BASE	0x00000100
-#define MEDIA_INTF_T_V4L_BASE	0x00000200
-#define MEDIA_INTF_T_ALSA_BASE	0x00000300
+#define MEDIA_INTF_T_DVB_BASE			0x00000100
+#define MEDIA_INTF_T_V4L_BASE			0x00000200
 
 /* Interface types */
 
-#define MEDIA_INTF_T_DVB_FE    	(MEDIA_INTF_T_DVB_BASE)
-#define MEDIA_INTF_T_DVB_DEMUX  (MEDIA_INTF_T_DVB_BASE + 1)
-#define MEDIA_INTF_T_DVB_DVR    (MEDIA_INTF_T_DVB_BASE + 2)
-#define MEDIA_INTF_T_DVB_CA     (MEDIA_INTF_T_DVB_BASE + 3)
-#define MEDIA_INTF_T_DVB_NET    (MEDIA_INTF_T_DVB_BASE + 4)
-
-#define MEDIA_INTF_T_V4L_VIDEO  (MEDIA_INTF_T_V4L_BASE)
-#define MEDIA_INTF_T_V4L_VBI    (MEDIA_INTF_T_V4L_BASE + 1)
-#define MEDIA_INTF_T_V4L_RADIO  (MEDIA_INTF_T_V4L_BASE + 2)
-#define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_INTF_T_V4L_BASE + 3)
-#define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_INTF_T_V4L_BASE + 4)
-#define MEDIA_INTF_T_V4L_TOUCH	(MEDIA_INTF_T_V4L_BASE + 5)
-
-#define MEDIA_INTF_T_ALSA_PCM_CAPTURE   (MEDIA_INTF_T_ALSA_BASE)
-#define MEDIA_INTF_T_ALSA_PCM_PLAYBACK  (MEDIA_INTF_T_ALSA_BASE + 1)
-#define MEDIA_INTF_T_ALSA_CONTROL       (MEDIA_INTF_T_ALSA_BASE + 2)
-#define MEDIA_INTF_T_ALSA_COMPRESS      (MEDIA_INTF_T_ALSA_BASE + 3)
-#define MEDIA_INTF_T_ALSA_RAWMIDI       (MEDIA_INTF_T_ALSA_BASE + 4)
-#define MEDIA_INTF_T_ALSA_HWDEP         (MEDIA_INTF_T_ALSA_BASE + 5)
-#define MEDIA_INTF_T_ALSA_SEQUENCER     (MEDIA_INTF_T_ALSA_BASE + 6)
-#define MEDIA_INTF_T_ALSA_TIMER         (MEDIA_INTF_T_ALSA_BASE + 7)
+#define MEDIA_INTF_T_DVB_FE    			(MEDIA_INTF_T_DVB_BASE)
+#define MEDIA_INTF_T_DVB_DEMUX  		(MEDIA_INTF_T_DVB_BASE + 1)
+#define MEDIA_INTF_T_DVB_DVR    		(MEDIA_INTF_T_DVB_BASE + 2)
+#define MEDIA_INTF_T_DVB_CA     		(MEDIA_INTF_T_DVB_BASE + 3)
+#define MEDIA_INTF_T_DVB_NET    		(MEDIA_INTF_T_DVB_BASE + 4)
+
+#define MEDIA_INTF_T_V4L_VIDEO  		(MEDIA_INTF_T_V4L_BASE)
+#define MEDIA_INTF_T_V4L_VBI    		(MEDIA_INTF_T_V4L_BASE + 1)
+#define MEDIA_INTF_T_V4L_RADIO  		(MEDIA_INTF_T_V4L_BASE + 2)
+#define MEDIA_INTF_T_V4L_SUBDEV 		(MEDIA_INTF_T_V4L_BASE + 3)
+#define MEDIA_INTF_T_V4L_SWRADIO 		(MEDIA_INTF_T_V4L_BASE + 4)
+#define MEDIA_INTF_T_V4L_TOUCH			(MEDIA_INTF_T_V4L_BASE + 5)
+
+#if defined(__KERNEL__)
 
 /*
- * MC next gen API definitions
+ * Connector functions
  *
- * NOTE: The declarations below are close to the MC RFC for the Media
- *	 Controller, the next generation. Yet, there are a few adjustments
- *	 to do, as we want to be able to have a functional API before
- *	 the MC properties change. Those will be properly marked below.
- *	 Please also notice that I removed "num_pads", "num_links",
- *	 from the proposal, as a proper userspace application will likely
- *	 use lists for pads/links, just as we intend to do in Kernelspace.
- *	 The API definition should be freed from fields that are bound to
- *	 some specific data structure.
+ * For now these should not be used in userspace, as some definitions may
+ * change.
  *
- * FIXME: Currently, I opted to name the new types as "media_v2", as this
- *	  won't cause any conflict with the Kernelspace namespace, nor with
- *	  the previous kAPI media_*_desc namespace. This can be changed
- *	  later, before the adding this API upstream.
+ * It is the responsibility of the entity drivers to add connectors and links.
  */
+#define MEDIA_ENT_F_CONN_RF			(MEDIA_ENT_F_BASE + 0x30001)
+#define MEDIA_ENT_F_CONN_SVIDEO			(MEDIA_ENT_F_BASE + 0x30002)
+#define MEDIA_ENT_F_CONN_COMPOSITE		(MEDIA_ENT_F_BASE + 0x30003)
 
+#endif
+
+/*
+ * MC next gen API definitions
+ */
 
 struct media_v2_entity {
 	__u32 id;
-	char name[64];		/* FIXME: move to a property? (RFC says so) */
+	char name[64];
 	__u32 function;		/* Main function of the entity */
 	__u32 reserved[6];
 } __attribute__ ((packed));
@@ -406,12 +339,66 @@ struct media_v2_topology {
 	__u64 ptr_links;
 } __attribute__ ((packed));
 
+
 /* ioctls */
 
-#define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct media_device_info)
-#define MEDIA_IOC_ENUM_ENTITIES		_IOWR('|', 0x01, struct media_entity_desc)
-#define MEDIA_IOC_ENUM_LINKS		_IOWR('|', 0x02, struct media_links_enum)
-#define MEDIA_IOC_SETUP_LINK		_IOWR('|', 0x03, struct media_link_desc)
-#define MEDIA_IOC_G_TOPOLOGY		_IOWR('|', 0x04, struct media_v2_topology)
+#define MEDIA_IOC_DEVICE_INFO	_IOWR('|', 0x00, struct media_device_info)
+#define MEDIA_IOC_ENUM_ENTITIES	_IOWR('|', 0x01, struct media_entity_desc)
+#define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
+#define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
+#define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
+
+
+#if !defined(__KERNEL__) || defined(__NEED_MEDIA_LEGACY_API)
+
+/*
+ * Legacy symbols used to avoid userspace compilation breakages.
+ * Do not use any of this in new applications!
+ *
+ * Those symbols map the entity function into types and should be
+ * used only on legacy programs for legacy hardware. Don't rely
+ * on those for MEDIA_IOC_G_TOPOLOGY.
+ */
+#define MEDIA_ENT_TYPE_SHIFT			16
+#define MEDIA_ENT_TYPE_MASK			0x00ff0000
+#define MEDIA_ENT_SUBTYPE_MASK			0x0000ffff
+
+#define MEDIA_ENT_T_DEVNODE_UNKNOWN		(MEDIA_ENT_F_OLD_BASE | \
+						 MEDIA_ENT_SUBTYPE_MASK)
+
+#define MEDIA_ENT_T_DEVNODE			MEDIA_ENT_F_OLD_BASE
+#define MEDIA_ENT_T_DEVNODE_V4L			MEDIA_ENT_F_IO_V4L
+#define MEDIA_ENT_T_DEVNODE_FB			(MEDIA_ENT_F_OLD_BASE + 2)
+#define MEDIA_ENT_T_DEVNODE_ALSA		(MEDIA_ENT_F_OLD_BASE + 3)
+#define MEDIA_ENT_T_DEVNODE_DVB			(MEDIA_ENT_F_OLD_BASE + 4)
+
+#define MEDIA_ENT_T_UNKNOWN			MEDIA_ENT_F_UNKNOWN
+#define MEDIA_ENT_T_V4L2_VIDEO			MEDIA_ENT_F_IO_V4L
+#define MEDIA_ENT_T_V4L2_SUBDEV			MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN
+#define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR		MEDIA_ENT_F_CAM_SENSOR
+#define MEDIA_ENT_T_V4L2_SUBDEV_FLASH		MEDIA_ENT_F_FLASH
+#define MEDIA_ENT_T_V4L2_SUBDEV_LENS		MEDIA_ENT_F_LENS
+#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER		MEDIA_ENT_F_ATV_DECODER
+#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER		MEDIA_ENT_F_TUNER
+
+/*
+ * There is still no ALSA support in the media controller. These
+ * defines should not have been added and we leave them here only
+ * in case some application tries to use these defines.
+ */
+#define MEDIA_INTF_T_ALSA_BASE			0x00000300
+#define MEDIA_INTF_T_ALSA_PCM_CAPTURE   	(MEDIA_INTF_T_ALSA_BASE)
+#define MEDIA_INTF_T_ALSA_PCM_PLAYBACK  	(MEDIA_INTF_T_ALSA_BASE + 1)
+#define MEDIA_INTF_T_ALSA_CONTROL       	(MEDIA_INTF_T_ALSA_BASE + 2)
+#define MEDIA_INTF_T_ALSA_COMPRESS      	(MEDIA_INTF_T_ALSA_BASE + 3)
+#define MEDIA_INTF_T_ALSA_RAWMIDI       	(MEDIA_INTF_T_ALSA_BASE + 4)
+#define MEDIA_INTF_T_ALSA_HWDEP         	(MEDIA_INTF_T_ALSA_BASE + 5)
+#define MEDIA_INTF_T_ALSA_SEQUENCER     	(MEDIA_INTF_T_ALSA_BASE + 6)
+#define MEDIA_INTF_T_ALSA_TIMER         	(MEDIA_INTF_T_ALSA_BASE + 7)
+
+/* Obsolete symbol for media_version, no longer used in the kernel */
+#define MEDIA_API_VERSION			KERNEL_VERSION(0, 1, 0)
+
+#endif
 
 #endif /* __LINUX_MEDIA_H */
-- 
2.16.1
