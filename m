Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:55103 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752388AbeCCUvW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 15:51:22 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 02/11] em28xx.h: Fix most coding style issues
Date: Sat,  3 Mar 2018 17:51:03 -0300
Message-Id: <9a2fa021e44303f4471cf03a155009cb2530d14c.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There used to have a lot of coding style issues there. The
ones detected by checkpatch, in strict mode, got fixed.

Still, we need to work more on it, in order to document all
struct fields using kernel-doc macros, but this will be done
on some future patch.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx.h | 297 ++++++++++++++++++++++----------------
 1 file changed, 174 insertions(+), 123 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 46ecf17758e8..90c4df4c8f84 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -23,6 +23,8 @@
 #ifndef _EM28XX_H
 #define _EM28XX_H
 
+#include <linux/bitfield.h>
+
 #define EM28XX_VERSION "0.2.2"
 #define DRIVER_DESC    "Empia em28xx device driver"
 
@@ -177,15 +179,17 @@
 /* max number of I2C buses on em28xx devices */
 #define NUM_I2C_BUSES	2
 
-/* isoc transfers: number of packets for each buffer
-   windows requests only 64 packets .. so we better do the same
-   this is what I found out for all alternate numbers there!
+/*
+ * isoc transfers: number of packets for each buffer
+ * windows requests only 64 packets .. so we better do the same
+ * this is what I found out for all alternate numbers there!
  */
 #define EM28XX_NUM_ISOC_PACKETS 64
 #define EM28XX_DVB_NUM_ISOC_PACKETS 64
 
-/* bulk transfers: transfer buffer size = packet size * packet multiplier
-   USB 2.0 spec says bulk packet size is always 512 bytes
+/*
+ * bulk transfers: transfer buffer size = packet size * packet multiplier
+ * USB 2.0 spec says bulk packet size is always 512 bytes
  */
 #define EM28XX_BULK_PACKET_MULTIPLIER 384
 #define EM28XX_DVB_BULK_PACKET_MULTIPLIER 384
@@ -206,64 +210,83 @@ enum em28xx_mode {
 
 struct em28xx;
 
+/**
+ * struct em28xx_usb_bufs - Contains URB-related buffer data
+ *
+ * @max_pkt_size:	max packet size of isoc transaction
+ * @num_packets:	number of packets in each buffer
+ * @num_bufs:		number of allocated urb
+ * @urb:		urb for isoc/bulk transfers
+ * @buf:		transfer buffers for isoc/bulk transfer
+ */
 struct em28xx_usb_bufs {
-		/* max packet size of isoc transaction */
 	int				max_pkt_size;
-
-		/* number of packets in each buffer */
 	int				num_packets;
-
-		/* number of allocated urbs */
 	int				num_bufs;
-
-		/* urb for isoc/bulk transfers */
 	struct urb			**urb;
-
-		/* transfer buffers for isoc/bulk transfer */
 	char				**buf;
 };
 
+/**
+ * struct em28xx_usb_ctl - Contains URB-related buffer data
+ *
+ * @analog_bufs:	isoc/bulk transfer buffers for analog mode
+ * @digital_bufs:	isoc/bulk transfer buffers for digital mode
+ * @vid_buf:		Stores already requested video buffers
+ * @vbi_buf:		Stores already requested VBI buffers
+ * @urb_data_copy:	copy data from URB
+ */
 struct em28xx_usb_ctl {
-		/* isoc/bulk transfer buffers for analog mode */
 	struct em28xx_usb_bufs		analog_bufs;
-
-		/* isoc/bulk transfer buffers for digital mode */
 	struct em28xx_usb_bufs		digital_bufs;
-
-		/* Stores already requested buffers */
 	struct em28xx_buffer	*vid_buf;
 	struct em28xx_buffer	*vbi_buf;
-
-		/* copy data from URB */
 	int (*urb_data_copy)(struct em28xx *dev, struct urb *urb);
-
 };
 
-/* Struct to enumberate video formats */
+/**
+ * struct em28xx_fmt - Struct to enumberate video formats
+ *
+ * @name:	Name for the video standard
+ * @fourcc:	v4l2 format id
+ * @depth:	mean number of bits to represent a pixel
+ * @reg:	em28xx register value to set it
+ */
 struct em28xx_fmt {
-	char  *name;
-	u32   fourcc;          /* v4l2 format id */
-	int   depth;
-	int   reg;
+	char	*name;
+	u32	fourcc;
+	int	depth;
+	int	reg;
 };
 
-/* buffer for one video frame */
+/**
+ * struct em28xx_buffer- buffer for storing one video frame
+ *
+ * @vb:		common v4l buffer stuff
+ * @list:	List to associate it with the other buffers
+ * @mem:	pointer to the buffer, as returned by vb2_plane_vaddr()
+ * @length:	length of the buffer, as returned by vb2_plane_size()
+ * @top_field:	If non-zero, indicate that the buffer is the top field
+ * @pos:	Indicate the next position of the buffer to be filled.
+ * @vb_buf:	pointer to vmalloc memory address in vb
+ *
+ * .. note::
+ *
+ *    in interlaced mode, @pos is reset to zero at the start of each new
+ *    field (not frame !)
+ */
 struct em28xx_buffer {
-	/* common v4l buffer stuff -- must be first */
-	struct vb2_v4l2_buffer vb;
-	struct list_head list;
+	struct vb2_v4l2_buffer	vb;		/* must be first */
 
-	void *mem;
-	unsigned int length;
-	int top_field;
+	struct list_head	list;
 
-	/* counter to control buffer fill */
-	unsigned int pos;
-	/* NOTE; in interlaced mode, this value is reset to zero at
-	 * the start of each new field (not frame !)		   */
+	void			*mem;
+	unsigned int		length;
+	int			top_field;
 
-	/* pointer to vmalloc memory address in vb */
-	char *vb_buf;
+	unsigned int		pos;
+
+	char			*vb_buf;
 };
 
 struct em28xx_dmaqueue {
@@ -305,20 +328,48 @@ enum em28xx_usb_audio_type {
 	EM28XX_USB_AUDIO_VENDOR,
 };
 
-/* em28xx has two audio inputs: tuner and line in.
-   However, on most devices, an auxiliary AC97 codec device is used.
-   The AC97 device may have several different inputs and outputs,
-   depending on their model. So, it is possible to use AC97 mixer to
-   address more than two different entries.
+/**
+ * em28xx_amux - describes the type of audio input used by em28xx
+ *
+ * @EM28XX_AMUX_VIDEO:
+ *	On devices without AC97, this is the only value that it is currently
+ *	allowed.
+ *	On devices with AC97, it corresponds to the AC97 mixer "Video" control.
+ * @EM28XX_AMUX_LINE_IN:
+ *	Only for devices with AC97. Corresponds to AC97 mixer "Line In".
+ * @EM28XX_AMUX_VIDEO2:
+ *	Only for devices with AC97. It means that em28xx should use "Line In"
+ *	And AC97 should use the "Video" mixer control.
+ * @EM28XX_AMUX_PHONE:
+ *	Only for devices with AC97. Corresponds to AC97 mixer "Phone".
+ * @EM28XX_AMUX_MIC:
+ *	Only for devices with AC97. Corresponds to AC97 mixer "Mic".
+ * @EM28XX_AMUX_CD:
+ *	Only for devices with AC97. Corresponds to AC97 mixer "CD".
+ * @EM28XX_AMUX_AUX:
+ *	Only for devices with AC97. Corresponds to AC97 mixer "Aux".
+ * @EM28XX_AMUX_PCM_OUT:
+ *	Only for devices with AC97. Corresponds to AC97 mixer "PCM out".
+ *
+ * The em28xx chip itself has only two audio inputs: tuner and line in.
+ * On almost all devices, only the tuner input is used.
+ *
+ * However, on most devices, an auxiliary AC97 codec device is used,
+ * usually connected to the em28xx tuner input (except for
+ * @EM28XX_AMUX_LINE_IN).
+ *
+ * The AC97 device typically have several different inputs and outputs.
+ * The exact number and description depends on their model.
+ *
+ * It is possible to AC97 to mixer more than one different entries at the
+ * same time, via the alsa mux.
  */
 enum em28xx_amux {
-	/* This is the only entry for em28xx tuner input */
-	EM28XX_AMUX_VIDEO,	/* em28xx tuner, AC97 mixer Video */
-
-	EM28XX_AMUX_LINE_IN,	/* AC97 mixer Line In */
+	EM28XX_AMUX_VIDEO,
+	EM28XX_AMUX_LINE_IN,
 
 	/* Some less-common mixer setups */
-	EM28XX_AMUX_VIDEO2,	/* em28xx Line in, AC97 mixer Video */
+	EM28XX_AMUX_VIDEO2,
 	EM28XX_AMUX_PHONE,
 	EM28XX_AMUX_MIC,
 	EM28XX_AMUX_CD,
@@ -328,14 +379,14 @@ enum em28xx_amux {
 
 enum em28xx_aout {
 	/* AC97 outputs */
-	EM28XX_AOUT_MASTER = 1 << 0,
-	EM28XX_AOUT_LINE   = 1 << 1,
-	EM28XX_AOUT_MONO   = 1 << 2,
-	EM28XX_AOUT_LFE    = 1 << 3,
-	EM28XX_AOUT_SURR   = 1 << 4,
+	EM28XX_AOUT_MASTER = BIT(0),
+	EM28XX_AOUT_LINE   = BIT(1),
+	EM28XX_AOUT_MONO   = BIT(2),
+	EM28XX_AOUT_LFE    = BIT(3),
+	EM28XX_AOUT_SURR   = BIT(4),
 
 	/* PCM IN Mixer - used by AC97_RECORD_SELECT register */
-	EM28XX_AOUT_PCM_IN = 1 << 7,
+	EM28XX_AOUT_PCM_IN = BIT(7),
 
 	/* Bits 10-8 are used to indicate the PCM IN record select */
 	EM28XX_AOUT_PCM_MIC_PCM = 0 << 8,
@@ -422,7 +473,7 @@ struct em28xx_board {
 	int vchannels;
 	int tuner_type;
 	int tuner_addr;
-	unsigned def_i2c_bus;	/* Default I2C bus */
+	unsigned int def_i2c_bus;	/* Default I2C bus */
 
 	/* i2c flags */
 	unsigned int tda9887_conf;
@@ -500,8 +551,8 @@ struct em28xx_v4l2 {
 	/* Videobuf2 */
 	struct vb2_queue vb_vidq;
 	struct vb2_queue vb_vbiq;
-	struct mutex vb_queue_lock;
-	struct mutex vb_vbi_queue_lock;
+	struct mutex vb_queue_lock;	/* Protects vb_vidq */
+	struct mutex vb_vbi_queue_lock;	/* Protects vb_vbiq */
 
 	u8 vinmode;
 	u8 vinctl;
@@ -527,8 +578,8 @@ struct em28xx_v4l2 {
 	/* Frame properties */
 	int width;		/* current frame width */
 	int height;		/* current frame height */
-	unsigned hscale;	/* horizontal scale factor (see datasheet) */
-	unsigned vscale;	/* vertical scale factor (see datasheet) */
+	unsigned int hscale;	/* horizontal scale factor (see datasheet) */
+	unsigned int vscale;	/* vertical scale factor (see datasheet) */
 	unsigned int vbi_width;
 	unsigned int vbi_height; /* lines per field */
 
@@ -546,7 +597,7 @@ struct em28xx_v4l2 {
 
 struct em28xx_audio {
 	char name[50];
-	unsigned num_urb;
+	unsigned int num_urb;
 	char **transfer_buffer;
 	struct urb **urb;
 	struct usb_device *udev;
@@ -559,7 +610,7 @@ struct em28xx_audio {
 	size_t period;
 
 	int users;
-	spinlock_t slock;
+	spinlock_t slock;		/* Protects struct em28xx_audio */
 
 	/* Controls streaming */
 	struct work_struct wq_trigger;	/* trigger to start/stop audio */
@@ -577,7 +628,7 @@ enum em28xx_i2c_algo_type {
 struct em28xx_i2c_bus {
 	struct em28xx *dev;
 
-	unsigned bus;
+	unsigned int bus;
 	enum em28xx_i2c_algo_type algo_type;
 };
 
@@ -585,19 +636,19 @@ struct em28xx_i2c_bus {
 struct em28xx {
 	struct kref ref;
 
-	/* Sub-module data */
+	// Sub-module data
 	struct em28xx_v4l2 *v4l2;
 	struct em28xx_dvb *dvb;
 	struct em28xx_audio adev;
 	struct em28xx_IR *ir;
 
-	/* generic device properties */
-	int model;		/* index in the device_data struct */
-	int devno;		/* marks the number of this device */
+	// generic device properties
+	int model;		// index in the device_data struct
+	int devno;		// marks the number of this device
 	enum em28xx_chip_id chip_id;
 
-	unsigned int is_em25xx:1;	/* em25xx/em276x/7x/8x family bridge */
-	unsigned int disconnected:1;	/* device has been diconnected */
+	unsigned int is_em25xx:1;	// em25xx/em276x/7x/8x family bridge
+	unsigned int disconnected:1;	// device has been diconnected
 	unsigned int has_video:1;
 	unsigned int is_audio_only:1;
 	unsigned int is_webcam:1;
@@ -608,82 +659,82 @@ struct em28xx {
 
 	struct em28xx_board board;
 
-	enum em28xx_sensor em28xx_sensor;	/* camera specific */
+	enum em28xx_sensor em28xx_sensor;	// camera specific
 
-	/* Some older em28xx chips needs a waiting time after writing */
+	// Some older em28xx chips needs a waiting time after writing
 	unsigned int wait_after_write;
 
 	struct list_head	devlist;
 
-	u32 i2s_speed;		/* I2S speed for audio digital stream */
+	u32 i2s_speed;		// I2S speed for audio digital stream
 
 	struct em28xx_audio_mode audio_mode;
 
-	int tuner_type;		/* type of the tuner */
+	int tuner_type;		// type of the tuner
 
-	/* i2c i/o */
+	// i2c i/o
 	struct i2c_adapter i2c_adap[NUM_I2C_BUSES];
 	struct i2c_client i2c_client[NUM_I2C_BUSES];
 	struct em28xx_i2c_bus i2c_bus[NUM_I2C_BUSES];
 
 	unsigned char eeprom_addrwidth_16bit:1;
-	unsigned def_i2c_bus;	/* Default I2C bus */
-	unsigned cur_i2c_bus;	/* Current I2C bus */
+	unsigned int def_i2c_bus;	// Default I2C bus
+	unsigned int cur_i2c_bus;	// Current I2C bus
 	struct rt_mutex i2c_bus_lock;
 
-	/* video for linux */
-	unsigned int ctl_input;	/* selected input */
-	unsigned int ctl_ainput;/* selected audio input */
-	unsigned int ctl_aoutput;/* selected audio output */
+	// video for linux
+	unsigned int ctl_input;	// selected input
+	unsigned int ctl_ainput;// selected audio input
+	unsigned int ctl_aoutput;// selected audio output
 	int mute;
 	int volume;
 
-	unsigned long hash;	/* eeprom hash - for boards with generic ID */
-	unsigned long i2c_hash;	/* i2c devicelist hash -
-				   for boards with generic ID */
+	unsigned long hash;	// eeprom hash - for boards with generic ID
+	unsigned long i2c_hash;	// i2c devicelist hash -
+				// for boards with generic ID
 
 	struct work_struct         request_module_wk;
 
-	/* locks */
-	struct mutex lock;
+	// locks
+	struct mutex lock;		/* protects em28xx struct */
 	struct mutex ctrl_urb_lock;	/* protects urb_buf */
 
-	/* resources in use */
+	// resources in use
 	unsigned int resources;
 
-	/* eeprom content */
+	// eeprom content
 	u8 *eedata;
 	u16 eedata_len;
 
-	/* Isoc control struct */
+	// Isoc control struct
 	struct em28xx_dmaqueue vidq;
 	struct em28xx_dmaqueue vbiq;
 	struct em28xx_usb_ctl usb_ctl;
-	spinlock_t slock;
+	spinlock_t slock; /* Protects em28xx video/vbi/dvb IRQ stream data */
 
-	/* usb transfer */
-	struct usb_interface *intf;	/* the usb interface */
-	u8 ifnum;		/* number of the assigned usb interface */
-	u8 analog_ep_isoc;	/* address of isoc endpoint for analog */
-	u8 analog_ep_bulk;	/* address of bulk endpoint for analog */
-	u8 dvb_ep_isoc;		/* address of isoc endpoint for DVB */
-	u8 dvb_ep_bulk;		/* address of bulk endpoint for DVB */
-	int alt;		/* alternate setting */
-	int max_pkt_size;	/* max packet size of the selected ep at alt */
-	int packet_multiplier;	/* multiplier for wMaxPacketSize, used for
-				   URB buffer size definition */
-	int num_alt;		/* number of alternative settings */
-	unsigned int *alt_max_pkt_size_isoc; /* array of isoc wMaxPacketSize */
-	unsigned int analog_xfer_bulk:1;	/* use bulk instead of isoc
-						   transfers for analog      */
-	int dvb_alt_isoc;	/* alternate setting for DVB isoc transfers */
-	unsigned int dvb_max_pkt_size_isoc;	/* isoc max packet size of the
-						   selected DVB ep at dvb_alt */
-	unsigned int dvb_xfer_bulk:1;		/* use bulk instead of isoc
-						   transfers for DVB          */
-	char urb_buf[URB_MAX_CTRL_SIZE];	/* urb control msg buffer */
+	// usb transfer
+	struct usb_interface *intf;	// the usb interface
+	u8 ifnum;		// number of the assigned usb interface
+	u8 analog_ep_isoc;	// address of isoc endpoint for analog
+	u8 analog_ep_bulk;	// address of bulk endpoint for analog
+	u8 dvb_ep_isoc;		// address of isoc endpoint for DVB
+	u8 dvb_ep_bulk;		// address of bulk endpoint for DVB
+	int alt;		// alternate setting
+	int max_pkt_size;	// max packet size of the selected ep at alt
+	int packet_multiplier;	// multiplier for wMaxPacketSize, used for
+				// URB buffer size definition
+	int num_alt;		// number of alternative settings
+	unsigned int *alt_max_pkt_size_isoc; // array of isoc wMaxPacketSize
+	unsigned int analog_xfer_bulk:1;	// use bulk instead of isoc
+						//   transfers for analog
+	int dvb_alt_isoc;	// alternate setting for DVB isoc transfers
+	unsigned int dvb_max_pkt_size_isoc;	// isoc max packet size of the
+						// selected DVB ep at dvb_alt
+	unsigned int dvb_xfer_bulk:1;		// use bulk instead of isoc
+						// transfers for DVB
+	char urb_buf[URB_MAX_CTRL_SIZE];	// urb control msg buffer
 
-	/* helper funcs that call usb_control_msg */
+	// helper funcs that call usb_control_msg
 	int (*em28xx_write_regs)(struct em28xx *dev, u16 reg,
 				 char *buf, int len);
 	int (*em28xx_read_reg)(struct em28xx *dev, u16 reg);
@@ -695,14 +746,14 @@ struct em28xx {
 
 	enum em28xx_mode mode;
 
-	/* Button state polling */
+	// Button state polling
 	struct delayed_work buttons_query_work;
 	u8 button_polling_addresses[EM28XX_NUM_BUTTON_ADDRESSES_MAX];
 	u8 button_polling_last_values[EM28XX_NUM_BUTTON_ADDRESSES_MAX];
 	u8 num_button_polling_addresses;
-	u16 button_polling_interval; /* [ms] */
-	/* Snapshot button input device */
-	char snapshot_button_path[30];	/* path of the input dev */
+	u16 button_polling_interval; // [ms]
+	// Snapshot button input device
+	char snapshot_button_path[30];	// path of the input dev
 	struct input_dev *sbutton_input_dev;
 
 #ifdef CONFIG_MEDIA_CONTROLLER
@@ -718,17 +769,17 @@ struct em28xx_ops {
 	struct list_head next;
 	char *name;
 	int id;
-	int (*init)(struct em28xx *);
-	int (*fini)(struct em28xx *);
-	int (*suspend)(struct em28xx *);
-	int (*resume)(struct em28xx *);
+	int (*init)(struct em28xx *dev);
+	int (*fini)(struct em28xx *dev);
+	int (*suspend)(struct em28xx *dev);
+	int (*resume)(struct em28xx *dev);
 };
 
 /* Provided by em28xx-i2c.c */
-void em28xx_do_i2c_scan(struct em28xx *dev, unsigned bus);
-int  em28xx_i2c_register(struct em28xx *dev, unsigned bus,
+void em28xx_do_i2c_scan(struct em28xx *dev, unsigned int bus);
+int  em28xx_i2c_register(struct em28xx *dev, unsigned int bus,
 			 enum em28xx_i2c_algo_type algo_type);
-int  em28xx_i2c_unregister(struct em28xx *dev, unsigned bus);
+int  em28xx_i2c_unregister(struct em28xx *dev, unsigned int bus);
 
 /* Provided by em28xx-core.c */
 int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
-- 
2.14.3
