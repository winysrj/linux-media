Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51666 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726288AbeI1Wbd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 18:31:33 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8SG6fUY060506
        for <linux-media@vger.kernel.org>; Fri, 28 Sep 2018 12:07:03 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2msnyx4u6e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Fri, 28 Sep 2018 12:07:01 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.vnet.ibm.com>;
        Fri, 28 Sep 2018 12:06:48 -0400
Subject: Re: [PATCH v3 2/2] media: platform: Add Aspeed Video Engine driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Eddie James <eajames@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, andrew@aj.id.au,
        openbmc@lists.ozlabs.org, robh+dt@kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org
References: <1537903629-14003-1-git-send-email-eajames@linux.ibm.com>
 <1537903629-14003-3-git-send-email-eajames@linux.ibm.com>
 <a78d4c7a-ac58-c23d-a683-23dce54be993@xs4all.nl>
From: Eddie James <eajames@linux.vnet.ibm.com>
Date: Fri, 28 Sep 2018 11:06:40 -0500
MIME-Version: 1.0
In-Reply-To: <a78d4c7a-ac58-c23d-a683-23dce54be993@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Message-Id: <b5ca3675-b27c-684b-559e-5dbd6876fd08@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/28/2018 06:30 AM, Hans Verkuil wrote:
> On 09/25/2018 09:27 PM, Eddie James wrote:
>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>> can capture and compress video data from digital or analog sources. With
>> the Aspeed chip acting a service processor, the Video Engine can capture
>> the host processor graphics output.
>>
>> Add a V4L2 driver to capture video data and compress it to JPEG images.
>> Make the video frames available through the V4L2 streaming interface.
>>
>> Signed-off-by: Eddie James <eajames@linux.ibm.com>
>> ---
>>   MAINTAINERS                           |    8 +
>>   drivers/media/platform/Kconfig        |    8 +
>>   drivers/media/platform/Makefile       |    1 +
>>   drivers/media/platform/aspeed-video.c | 1645 +++++++++++++++++++++++++++++++++
>>   4 files changed, 1662 insertions(+)
>>   create mode 100644 drivers/media/platform/aspeed-video.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 903d647..a9945af 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -2367,6 +2367,14 @@ S:	Maintained
>>   F:	Documentation/hwmon/asc7621
>>   F:	drivers/hwmon/asc7621.c
>>   
>> +ASPEED VIDEO ENGINE DRIVER
>> +M:	Eddie James <eajames@linux.ibm.com>
>> +L:	linux-media@vger.kernel.org
>> +L:	openbmc@lists.ozlabs.org (moderated for non-subscribers)
>> +S:	Maintained
>> +F:	drivers/media/platform/aspeed-video.c
>> +F:	Documentation/devicetree/bindings/media/aspeed-video.txt
>> +
>>   ASUS NOTEBOOKS AND EEEPC ACPI/WMI EXTRAS DRIVERS
>>   M:	Corentin Chary <corentin.chary@gmail.com>
>>   L:	acpi4asus-user@lists.sourceforge.net
>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> index 936675d..f211253 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -32,6 +32,14 @@ source "drivers/media/platform/davinci/Kconfig"
>>   
>>   source "drivers/media/platform/omap/Kconfig"
>>   
>> +config VIDEO_ASPEED
>> +	tristate "Aspeed AST2400 and AST2500 Video Engine driver"
>> +	depends on VIDEO_V4L2
>> +	help
>> +	  Support for the Aspeed Video Engine (VE) embedded in the Aspeed
>> +	  AST2400 and AST2500 SOCs. The VE can capture and compress video data
>> +	  from digital or analog sources.
>> +
>>   config VIDEO_SH_VOU
>>   	tristate "SuperH VOU video output driver"
>>   	depends on MEDIA_CAMERA_SUPPORT
>> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
>> index 6ab6200..2973953 100644
>> --- a/drivers/media/platform/Makefile
>> +++ b/drivers/media/platform/Makefile
>> @@ -3,6 +3,7 @@
>>   # Makefile for the video capture/playback device drivers.
>>   #
>>   
>> +obj-$(CONFIG_VIDEO_ASPEED)		+= aspeed-video.o
>>   obj-$(CONFIG_VIDEO_CADENCE)		+= cadence/
>>   obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
>>   obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
>> diff --git a/drivers/media/platform/aspeed-video.c b/drivers/media/platform/aspeed-video.c
>> new file mode 100644
>> index 0000000..ad82cf3
>> --- /dev/null
>> +++ b/drivers/media/platform/aspeed-video.c
>> @@ -0,0 +1,1645 @@
>> +// SPDX-License-Identifier: GPL-2.0+
>> +
>> +#include <linux/atomic.h>
>> +#include <linux/bitfield.h>
>> +#include <linux/clk.h>
>> +#include <linux/delay.h>
>> +#include <linux/device.h>
>> +#include <linux/dma-mapping.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/jiffies.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/of.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/of_reserved_mem.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/reset.h>
>> +#include <linux/sched.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/string.h>
>> +#include <linux/v4l2-controls.h>
>> +#include <linux/videodev2.h>
>> +#include <linux/wait.h>
>> +#include <linux/workqueue.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-dev.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-event.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/videobuf2-core.h>
> You can drop this header
>
>> +#include <media/videobuf2-dma-contig.h>
>> +#include <media/videobuf2-v4l2.h>
> and this header since videobuf2-dma-contig.h is sufficient.
>
>> +
>> +#define DEVICE_NAME			"aspeed-video"
>> +
>> +#define ASPEED_VIDEO_JPEG_NUM_QUALITIES	12
>> +#define ASPEED_VIDEO_JPEG_HEADER_SIZE	10
>> +#define ASPEED_VIDEO_JPEG_QUANT_SIZE	116
>> +#define ASPEED_VIDEO_JPEG_DCT_SIZE	34
>> +
>> +#define MAX_FRAME_RATE			60
>> +#define MAX_HEIGHT			1200
>> +#define MAX_WIDTH			1920
>> +
>> +#define NUM_POLARITY_CHECKS		10
>> +#define INVALID_RESOLUTION_RETRIES	2
>> +#define INVALID_RESOLUTION_DELAY	msecs_to_jiffies(250)
>> +#define RESOLUTION_CHANGE_DELAY		msecs_to_jiffies(500)
>> +#define MODE_DETECT_TIMEOUT		msecs_to_jiffies(500)
>> +#define STOP_TIMEOUT			msecs_to_jiffies(250)
>> +#define DIRECT_FETCH_THRESHOLD		0x0c0000 /* 1024 * 768 */
>> +
>> +#define VE_MAX_SRC_BUFFER_SIZE		0x8ca000 /* 1920 * 1200, 32bpp */
>> +#define VE_JPEG_HEADER_SIZE		0x006000 /* 512 * 12 * 4 */
>> +
>> +#define VE_PROTECTION_KEY		0x000
>> +#define  VE_PROTECTION_KEY_UNLOCK	0x1a038aa8
>> +
>> +#define VE_SEQ_CTRL			0x004
>> +#define  VE_SEQ_CTRL_TRIG_MODE_DET	BIT(0)
>> +#define  VE_SEQ_CTRL_TRIG_CAPTURE	BIT(1)
>> +#define  VE_SEQ_CTRL_FORCE_IDLE		BIT(2)
>> +#define  VE_SEQ_CTRL_MULT_FRAME		BIT(3)
>> +#define  VE_SEQ_CTRL_TRIG_COMP		BIT(4)
>> +#define  VE_SEQ_CTRL_AUTO_COMP		BIT(5)
>> +#define  VE_SEQ_CTRL_EN_WATCHDOG	BIT(7)
>> +#define  VE_SEQ_CTRL_YUV420		BIT(10)
>> +#define  VE_SEQ_CTRL_COMP_FMT		GENMASK(11, 10)
>> +#define  VE_SEQ_CTRL_HALT		BIT(12)
>> +#define  VE_SEQ_CTRL_EN_WATCHDOG_COMP	BIT(14)
>> +#define  VE_SEQ_CTRL_TRIG_JPG		BIT(15)
>> +#define  VE_SEQ_CTRL_CAP_BUSY		BIT(16)
>> +#define  VE_SEQ_CTRL_COMP_BUSY		BIT(18)
>> +
>> +#ifdef CONFIG_MACH_ASPEED_G5
>> +#define  VE_SEQ_CTRL_JPEG_MODE		BIT(13)	/* AST2500 */
>> +#else
>> +#define  VE_SEQ_CTRL_JPEG_MODE		BIT(8)	/* AST2400 */
>> +#endif /* CONFIG_MACH_ASPEED_G5 */
>> +
>> +#define VE_CTRL				0x008
>> +#define  VE_CTRL_HSYNC_POL		BIT(0)
>> +#define  VE_CTRL_VSYNC_POL		BIT(1)
>> +#define  VE_CTRL_SOURCE			BIT(2)
>> +#define  VE_CTRL_INT_DE			BIT(4)
>> +#define  VE_CTRL_DIRECT_FETCH		BIT(5)
>> +#define  VE_CTRL_YUV			BIT(6)
>> +#define  VE_CTRL_RGB			BIT(7)
>> +#define  VE_CTRL_CAPTURE_FMT		GENMASK(7, 6)
>> +#define  VE_CTRL_AUTO_OR_CURSOR		BIT(8)
>> +#define  VE_CTRL_CLK_INVERSE		BIT(11)
>> +#define  VE_CTRL_CLK_DELAY		GENMASK(11, 9)
>> +#define  VE_CTRL_INTERLACE		BIT(14)
>> +#define  VE_CTRL_HSYNC_POL_CTRL		BIT(15)
>> +#define  VE_CTRL_FRC			GENMASK(23, 16)
>> +
>> +#define VE_TGS_0			0x00c
>> +#define VE_TGS_1			0x010
>> +#define  VE_TGS_FIRST			GENMASK(28, 16)
>> +#define  VE_TGS_LAST			GENMASK(12, 0)
>> +
>> +#define VE_SCALING_FACTOR		0x014
>> +#define VE_SCALING_FILTER0		0x018
>> +#define VE_SCALING_FILTER1		0x01c
>> +#define VE_SCALING_FILTER2		0x020
>> +#define VE_SCALING_FILTER3		0x024
>> +
>> +#define VE_CAP_WINDOW			0x030
>> +#define VE_COMP_WINDOW			0x034
>> +#define VE_COMP_PROC_OFFSET		0x038
>> +#define VE_COMP_OFFSET			0x03c
>> +#define VE_JPEG_ADDR			0x040
>> +#define VE_SRC0_ADDR			0x044
>> +#define VE_SRC_SCANLINE_OFFSET		0x048
>> +#define VE_SRC1_ADDR			0x04c
>> +#define VE_COMP_ADDR			0x054
>> +
>> +#define VE_STREAM_BUF_SIZE		0x058
>> +#define  VE_STREAM_BUF_SIZE_N_PACKETS	GENMASK(5, 3)
>> +#define  VE_STREAM_BUF_SIZE_P_SIZE	GENMASK(2, 0)
>> +
>> +#define VE_COMP_CTRL			0x060
>> +#define  VE_COMP_CTRL_VQ_DCT_ONLY	BIT(0)
>> +#define  VE_COMP_CTRL_VQ_4COLOR		BIT(1)
>> +#define  VE_COMP_CTRL_QUANTIZE		BIT(2)
>> +#define  VE_COMP_CTRL_EN_BQ		BIT(4)
>> +#define  VE_COMP_CTRL_EN_CRYPTO		BIT(5)
>> +#define  VE_COMP_CTRL_DCT_CHR		GENMASK(10, 6)
>> +#define  VE_COMP_CTRL_DCT_LUM		GENMASK(15, 11)
>> +#define  VE_COMP_CTRL_EN_HQ		BIT(16)
>> +#define  VE_COMP_CTRL_RSVD		BIT(19)
>> +#define  VE_COMP_CTRL_ENCODE		GENMASK(21, 20)
>> +#define  VE_COMP_CTRL_HQ_DCT_CHR	GENMASK(26, 22)
>> +#define  VE_COMP_CTRL_HQ_DCT_LUM	GENMASK(31, 27)
>> +
>> +#define VE_OFFSET_COMP_STREAM		0x078
>> +
>> +#define VE_SRC_LR_EDGE_DET		0x090
>> +#define  VE_SRC_LR_EDGE_DET_LEFT	GENMASK(11, 0)
>> +#define  VE_SRC_LR_EDGE_DET_NO_V	BIT(12)
>> +#define  VE_SRC_LR_EDGE_DET_NO_H	BIT(13)
>> +#define  VE_SRC_LR_EDGE_DET_NO_DISP	BIT(14)
>> +#define  VE_SRC_LR_EDGE_DET_NO_CLK	BIT(15)
>> +#define  VE_SRC_LR_EDGE_DET_RT_SHF	16
>> +#define  VE_SRC_LR_EDGE_DET_RT		GENMASK(27, VE_SRC_LR_EDGE_DET_RT_SHF)
>> +#define  VE_SRC_LR_EDGE_DET_INTERLACE	BIT(31)
>> +
>> +#define VE_SRC_TB_EDGE_DET		0x094
>> +#define  VE_SRC_TB_EDGE_DET_TOP		GENMASK(12, 0)
>> +#define  VE_SRC_TB_EDGE_DET_BOT_SHF	16
>> +#define  VE_SRC_TB_EDGE_DET_BOT		GENMASK(28, VE_SRC_TB_EDGE_DET_BOT_SHF)
>> +
>> +#define VE_MODE_DETECT_STATUS		0x098
>> +#define  VE_MODE_DETECT_STATUS_VSYNC	BIT(28)
>> +#define  VE_MODE_DETECT_STATUS_HSYNC	BIT(29)
>> +
>> +#define VE_INTERRUPT_CTRL		0x304
>> +#define VE_INTERRUPT_STATUS		0x308
>> +#define  VE_INTERRUPT_MODE_DETECT_WD	BIT(0)
>> +#define  VE_INTERRUPT_CAPTURE_COMPLETE	BIT(1)
>> +#define  VE_INTERRUPT_COMP_READY	BIT(2)
>> +#define  VE_INTERRUPT_COMP_COMPLETE	BIT(3)
>> +#define  VE_INTERRUPT_MODE_DETECT	BIT(4)
>> +#define  VE_INTERRUPT_FRAME_COMPLETE	BIT(5)
>> +#define  VE_INTERRUPT_DECODE_ERR	BIT(6)
>> +#define  VE_INTERRUPT_HALT_READY	BIT(8)
>> +#define  VE_INTERRUPT_HANG_WD		BIT(9)
>> +#define  VE_INTERRUPT_STREAM_DESC	BIT(10)
>> +#define  VE_INTERRUPT_VSYNC_DESC	BIT(11)
>> +
>> +#define VE_MODE_DETECT			0x30c
>> +#define VE_MEM_RESTRICT_START		0x310
>> +#define VE_MEM_RESTRICT_END		0x314
>> +
>> +enum {
>> +	VIDEO_MODE_DETECT_DONE,
>> +	VIDEO_RES_CHANGE,
>> +	VIDEO_STREAMING,
>> +	VIDEO_FRAME_INPRG,
>> +};
>> +
>> +struct aspeed_video_addr {
>> +	unsigned int size;
>> +	dma_addr_t dma;
>> +	void *virt;
>> +};
>> +
>> +struct aspeed_video_buffer {
>> +	struct vb2_v4l2_buffer vb;
>> +	struct list_head link;
>> +};
>> +
>> +#define to_aspeed_video_buffer(x) \
>> +	container_of((x), struct aspeed_video_buffer, vb)
>> +
>> +struct aspeed_video {
>> +	void __iomem *base;
>> +	struct clk *eclk;
>> +	struct clk *vclk;
>> +	struct reset_control *rst;
>> +
>> +	struct device *dev;
>> +	struct v4l2_ctrl_handler ctrl_handler;
>> +	struct v4l2_device v4l2_dev;
>> +	struct v4l2_pix_format v4l2_fmt;
> Nitpick: I'd rename v4l2_fmt to pix_fmt. v4l2_fmt suggests that it is a v4l2_format
> struct, which it no longer is.
>
>> +	struct vb2_queue queue;
>> +	struct video_device vdev;
>> +	struct mutex video_lock;
>> +
>> +	atomic_t clients;
>> +	wait_queue_head_t wait;
>> +	spinlock_t lock;
>> +	struct delayed_work res_work;
>> +	struct list_head buffers;
>> +	unsigned long flags;
>> +	unsigned int sequence;
>> +
>> +	unsigned int max_compressed_size;
>> +	struct aspeed_video_addr srcs[2];
>> +	struct aspeed_video_addr jpeg;
>> +
>> +	bool yuv420;
>> +	unsigned int frame_rate;
>> +	unsigned int jpeg_quality;
>> +	unsigned int height;
>> +	unsigned int width;
>> +};
>> +
>> +#define to_aspeed_video(x) container_of((x), struct aspeed_video, v4l2_dev)
>> +
>> +static const u32 aspeed_video_jpeg_header[ASPEED_VIDEO_JPEG_HEADER_SIZE] = {
>> +	0xE0FFD8FF, 0x464A1000, 0x01004649, 0x60000101, 0x00006000, 0x0F00FEFF,
>> +	0x00002D05, 0x00000000, 0x00000000, 0x00DBFF00
>> +};
>> +
>> +static const u32 aspeed_video_jpeg_quant[ASPEED_VIDEO_JPEG_QUANT_SIZE] = {
>> +	0x081100C0, 0x00000000, 0x00110103, 0x03011102, 0xC4FF0111, 0x00001F00,
>> +	0x01010501, 0x01010101, 0x00000000, 0x00000000, 0x04030201, 0x08070605,
>> +	0xFF0B0A09, 0x10B500C4, 0x03010200, 0x03040203, 0x04040505, 0x7D010000,
>> +	0x00030201, 0x12051104, 0x06413121, 0x07615113, 0x32147122, 0x08A19181,
>> +	0xC1B14223, 0xF0D15215, 0x72623324, 0x160A0982, 0x1A191817, 0x28272625,
>> +	0x35342A29, 0x39383736, 0x4544433A, 0x49484746, 0x5554534A, 0x59585756,
>> +	0x6564635A, 0x69686766, 0x7574736A, 0x79787776, 0x8584837A, 0x89888786,
>> +	0x9493928A, 0x98979695, 0xA3A29A99, 0xA7A6A5A4, 0xB2AAA9A8, 0xB6B5B4B3,
>> +	0xBAB9B8B7, 0xC5C4C3C2, 0xC9C8C7C6, 0xD4D3D2CA, 0xD8D7D6D5, 0xE2E1DAD9,
>> +	0xE6E5E4E3, 0xEAE9E8E7, 0xF4F3F2F1, 0xF8F7F6F5, 0xC4FFFAF9, 0x00011F00,
>> +	0x01010103, 0x01010101, 0x00000101, 0x00000000, 0x04030201, 0x08070605,
>> +	0xFF0B0A09, 0x11B500C4, 0x02010200, 0x04030404, 0x04040507, 0x77020100,
>> +	0x03020100, 0x21050411, 0x41120631, 0x71610751, 0x81322213, 0x91421408,
>> +	0x09C1B1A1, 0xF0523323, 0xD1726215, 0x3424160A, 0x17F125E1, 0x261A1918,
>> +	0x2A292827, 0x38373635, 0x44433A39, 0x48474645, 0x54534A49, 0x58575655,
>> +	0x64635A59, 0x68676665, 0x74736A69, 0x78777675, 0x83827A79, 0x87868584,
>> +	0x928A8988, 0x96959493, 0x9A999897, 0xA5A4A3A2, 0xA9A8A7A6, 0xB4B3B2AA,
>> +	0xB8B7B6B5, 0xC3C2BAB9, 0xC7C6C5C4, 0xD2CAC9C8, 0xD6D5D4D3, 0xDAD9D8D7,
>> +	0xE5E4E3E2, 0xE9E8E7E6, 0xF4F3F2EA, 0xF8F7F6F5, 0xDAFFFAF9, 0x01030C00,
>> +	0x03110200, 0x003F0011
>> +};
>> +
>> +static const u32 aspeed_video_jpeg_dct[ASPEED_VIDEO_JPEG_NUM_QUALITIES]
>> +				      [ASPEED_VIDEO_JPEG_DCT_SIZE] = {
>> +	{ 0x0D140043, 0x0C0F110F, 0x11101114, 0x17141516, 0x1E20321E,
>> +	  0x3D1E1B1B, 0x32242E2B, 0x4B4C3F48, 0x44463F47, 0x61735A50,
>> +	  0x566C5550, 0x88644644, 0x7A766C65, 0x4D808280, 0x8C978D60,
>> +	  0x7E73967D, 0xDBFF7B80, 0x1F014300, 0x272D2121, 0x3030582D,
>> +	  0x697BB958, 0xB8B9B97B, 0xB9B8A6A6, 0xB9B9B9B9, 0xB9B9B9B9,
>> +	  0xB9B9B9B9, 0xB9B9B9B9, 0xB9B9B9B9, 0xB9B9B9B9, 0xB9B9B9B9,
>> +	  0xB9B9B9B9, 0xB9B9B9B9, 0xB9B9B9B9, 0xFFB9B9B9 },
>> +	{ 0x0C110043, 0x0A0D0F0D, 0x0F0E0F11, 0x14111213, 0x1A1C2B1A,
>> +	  0x351A1818, 0x2B1F2826, 0x4142373F, 0x3C3D373E, 0x55644E46,
>> +	  0x4B5F4A46, 0x77573D3C, 0x6B675F58, 0x43707170, 0x7A847B54,
>> +	  0x6E64836D, 0xDBFF6C70, 0x1B014300, 0x22271D1D, 0x2A2A4C27,
>> +	  0x5B6BA04C, 0xA0A0A06B, 0xA0A0A0A0, 0xA0A0A0A0, 0xA0A0A0A0,
>> +	  0xA0A0A0A0, 0xA0A0A0A0, 0xA0A0A0A0, 0xA0A0A0A0, 0xA0A0A0A0,
>> +	  0xA0A0A0A0, 0xA0A0A0A0, 0xA0A0A0A0, 0xFFA0A0A0 },
>> +	{ 0x090E0043, 0x090A0C0A, 0x0C0B0C0E, 0x110E0F10, 0x15172415,
>> +	  0x2C151313, 0x241A211F, 0x36372E34, 0x31322E33, 0x4653413A,
>> +	  0x3E4E3D3A, 0x62483231, 0x58564E49, 0x385D5E5D, 0x656D6645,
>> +	  0x5B536C5A, 0xDBFF595D, 0x16014300, 0x1C201818, 0x22223F20,
>> +	  0x4B58853F, 0x85858558, 0x85858585, 0x85858585, 0x85858585,
>> +	  0x85858585, 0x85858585, 0x85858585, 0x85858585, 0x85858585,
>> +	  0x85858585, 0x85858585, 0x85858585, 0xFF858585 },
>> +	{ 0x070B0043, 0x07080A08, 0x0A090A0B, 0x0D0B0C0C, 0x11121C11,
>> +	  0x23110F0F, 0x1C141A19, 0x2B2B2429, 0x27282428, 0x3842332E,
>> +	  0x313E302E, 0x4E392827, 0x46443E3A, 0x2C4A4A4A, 0x50565137,
>> +	  0x48425647, 0xDBFF474A, 0x12014300, 0x161A1313, 0x1C1C331A,
>> +	  0x3D486C33, 0x6C6C6C48, 0x6C6C6C6C, 0x6C6C6C6C, 0x6C6C6C6C,
>> +	  0x6C6C6C6C, 0x6C6C6C6C, 0x6C6C6C6C, 0x6C6C6C6C, 0x6C6C6C6C,
>> +	  0x6C6C6C6C, 0x6C6C6C6C, 0x6C6C6C6C, 0xFF6C6C6C },
>> +	{ 0x06090043, 0x05060706, 0x07070709, 0x0A09090A, 0x0D0E160D,
>> +	  0x1B0D0C0C, 0x16101413, 0x21221C20, 0x1E1F1C20, 0x2B332824,
>> +	  0x26302624, 0x3D2D1F1E, 0x3735302D, 0x22393A39, 0x3F443F2B,
>> +	  0x38334338, 0xDBFF3739, 0x0D014300, 0x11130E0E, 0x15152613,
>> +	  0x2D355026, 0x50505035, 0x50505050, 0x50505050, 0x50505050,
>> +	  0x50505050, 0x50505050, 0x50505050, 0x50505050, 0x50505050,
>> +	  0x50505050, 0x50505050, 0x50505050, 0xFF505050 },
>> +	{ 0x04060043, 0x03040504, 0x05040506, 0x07060606, 0x09090F09,
>> +	  0x12090808, 0x0F0A0D0D, 0x16161315, 0x14151315, 0x1D221B18,
>> +	  0x19201918, 0x281E1514, 0x2423201E, 0x17262726, 0x2A2D2A1C,
>> +	  0x25222D25, 0xDBFF2526, 0x09014300, 0x0B0D0A0A, 0x0E0E1A0D,
>> +	  0x1F25371A, 0x37373725, 0x37373737, 0x37373737, 0x37373737,
>> +	  0x37373737, 0x37373737, 0x37373737, 0x37373737, 0x37373737,
>> +	  0x37373737, 0x37373737, 0x37373737, 0xFF373737 },
>> +	{ 0x02030043, 0x01020202, 0x02020203, 0x03030303, 0x04040704,
>> +	  0x09040404, 0x07050606, 0x0B0B090A, 0x0A0A090A, 0x0E110D0C,
>> +	  0x0C100C0C, 0x140F0A0A, 0x1211100F, 0x0B131313, 0x1516150E,
>> +	  0x12111612, 0xDBFF1213, 0x04014300, 0x05060505, 0x07070D06,
>> +	  0x0F121B0D, 0x1B1B1B12, 0x1B1B1B1B, 0x1B1B1B1B, 0x1B1B1B1B,
>> +	  0x1B1B1B1B, 0x1B1B1B1B, 0x1B1B1B1B, 0x1B1B1B1B, 0x1B1B1B1B,
>> +	  0x1B1B1B1B, 0x1B1B1B1B, 0x1B1B1B1B, 0xFF1B1B1B },
>> +	{ 0x01020043, 0x01010101, 0x01010102, 0x02020202, 0x03030503,
>> +	  0x06030202, 0x05030404, 0x07070607, 0x06070607, 0x090B0908,
>> +	  0x080A0808, 0x0D0A0706, 0x0C0B0A0A, 0x070C0D0C, 0x0E0F0E09,
>> +	  0x0C0B0F0C, 0xDBFF0C0C, 0x03014300, 0x03040303, 0x04040804,
>> +	  0x0A0C1208, 0x1212120C, 0x12121212, 0x12121212, 0x12121212,
>> +	  0x12121212, 0x12121212, 0x12121212, 0x12121212, 0x12121212,
>> +	  0x12121212, 0x12121212, 0x12121212, 0xFF121212 },
>> +	{ 0x01020043, 0x01010101, 0x01010102, 0x02020202, 0x03030503,
>> +	  0x06030202, 0x05030404, 0x07070607, 0x06070607, 0x090B0908,
>> +	  0x080A0808, 0x0D0A0706, 0x0C0B0A0A, 0x070C0D0C, 0x0E0F0E09,
>> +	  0x0C0B0F0C, 0xDBFF0C0C, 0x02014300, 0x03030202, 0x04040703,
>> +	  0x080A0F07, 0x0F0F0F0A, 0x0F0F0F0F, 0x0F0F0F0F, 0x0F0F0F0F,
>> +	  0x0F0F0F0F, 0x0F0F0F0F, 0x0F0F0F0F, 0x0F0F0F0F, 0x0F0F0F0F,
>> +	  0x0F0F0F0F, 0x0F0F0F0F, 0x0F0F0F0F, 0xFF0F0F0F },
>> +	{ 0x01010043, 0x01010101, 0x01010101, 0x01010101, 0x02020302,
>> +	  0x04020202, 0x03020303, 0x05050405, 0x05050405, 0x07080606,
>> +	  0x06080606, 0x0A070505, 0x09080807, 0x05090909, 0x0A0B0A07,
>> +	  0x09080B09, 0xDBFF0909, 0x02014300, 0x02030202, 0x03030503,
>> +	  0x07080C05, 0x0C0C0C08, 0x0C0C0C0C, 0x0C0C0C0C, 0x0C0C0C0C,
>> +	  0x0C0C0C0C, 0x0C0C0C0C, 0x0C0C0C0C, 0x0C0C0C0C, 0x0C0C0C0C,
>> +	  0x0C0C0C0C, 0x0C0C0C0C, 0x0C0C0C0C, 0xFF0C0C0C },
>> +	{ 0x01010043, 0x01010101, 0x01010101, 0x01010101, 0x01010201,
>> +	  0x03010101, 0x02010202, 0x03030303, 0x03030303, 0x04050404,
>> +	  0x04050404, 0x06050303, 0x06050505, 0x03060606, 0x07070704,
>> +	  0x06050706, 0xDBFF0606, 0x01014300, 0x01020101, 0x02020402,
>> +	  0x05060904, 0x09090906, 0x09090909, 0x09090909, 0x09090909,
>> +	  0x09090909, 0x09090909, 0x09090909, 0x09090909, 0x09090909,
>> +	  0x09090909, 0x09090909, 0x09090909, 0xFF090909 },
>> +	{ 0x01010043, 0x01010101, 0x01010101, 0x01010101, 0x01010101,
>> +	  0x01010101, 0x01010101, 0x01010101, 0x01010101, 0x02020202,
>> +	  0x02020202, 0x03020101, 0x03020202, 0x01030303, 0x03030302,
>> +	  0x03020303, 0xDBFF0403, 0x01014300, 0x01010101, 0x01010201,
>> +	  0x03040602, 0x06060604, 0x06060606, 0x06060606, 0x06060606,
>> +	  0x06060606, 0x06060606, 0x06060606, 0x06060606, 0x06060606,
>> +	  0x06060606, 0x06060606, 0x06060606, 0xFF060606 }
>> +};
> Please lower case the A-F values in these arrays.
>
>> +
>> +static void aspeed_video_init_jpeg_table(u32 *table, bool yuv420)
>> +{
>> +	int i;
>> +	unsigned int base;
>> +
>> +	for (i = 0; i < ASPEED_VIDEO_JPEG_NUM_QUALITIES; i++) {
>> +		base = 256 * i;	/* AST HW requires this header spacing */
>> +		memcpy(&table[base], aspeed_video_jpeg_header,
>> +		       sizeof(aspeed_video_jpeg_header));
>> +
>> +		base += ASPEED_VIDEO_JPEG_HEADER_SIZE;
>> +		memcpy(&table[base], aspeed_video_jpeg_dct[i],
>> +		       sizeof(aspeed_video_jpeg_dct[i]));
>> +
>> +		base += ASPEED_VIDEO_JPEG_DCT_SIZE;
>> +		memcpy(&table[base], aspeed_video_jpeg_quant,
>> +		       sizeof(aspeed_video_jpeg_quant));
>> +
>> +		if (yuv420)
>> +			table[base + 2] = 0x00220103;
>> +	}
>> +}
>> +
>> +static void aspeed_video_update(struct aspeed_video *video, u32 reg,
>> +				unsigned long mask, u32 bits)
> You probably want to use u32 for the mask.
>
>> +{
>> +	u32 t = readl(video->base + reg);
>> +	u32 before = t;
>> +
>> +	t &= mask;
>> +	t |= bits;
>> +	writel(t, video->base + reg);
>> +	dev_dbg(video->dev, "update %03x[%08x -> %08x]\n", reg, before,
>> +		readl(video->base + reg));
>> +}
>> +
>> +static u32 aspeed_video_read(struct aspeed_video *video, u32 reg)
>> +{
>> +	u32 t = readl(video->base + reg);
>> +
>> +	dev_dbg(video->dev, "read %03x[%08x]\n", reg, t);
>> +	return t;
>> +}
>> +
>> +static void aspeed_video_write(struct aspeed_video *video, u32 reg, u32 val)
>> +{
>> +	writel(val, video->base + reg);
>> +	dev_dbg(video->dev, "write %03x[%08x]\n", reg,
>> +		readl(video->base + reg));
>> +}
>> +
>> +static bool aspeed_video_engine_busy(struct aspeed_video *video)
>> +{
>> +	u32 seq_ctrl = aspeed_video_read(video, VE_SEQ_CTRL);
>> +
>> +	if (!(seq_ctrl & VE_SEQ_CTRL_COMP_BUSY) ||
>> +	    !(seq_ctrl & VE_SEQ_CTRL_CAP_BUSY)) {
>> +		dev_info(video->dev, "video engine busy\n");
> Would dev_dbg be better to avoid spamming the kernel log?

Really this is an error condition where the engine hasn't stopped after 
it's completed the frame, or hasn't stopped after we've asked it to. So 
maybe I should use dev_err instead. It shouldn't happen in normal operation.

>
>> +		return true;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>> +static int aspeed_video_start_frame(struct aspeed_video *video)
>> +{
>> +	dma_addr_t addr;
>> +	unsigned long flags;
>> +	struct aspeed_video_buffer *buf;
>> +
>> +	if (aspeed_video_engine_busy(video))
>> +		return -EBUSY;
>> +
>> +	spin_lock_irqsave(&video->lock, flags);
>> +	buf = list_first_entry_or_null(&video->buffers,
>> +				       struct aspeed_video_buffer, link);
>> +	if (!buf) {
>> +		spin_unlock_irqrestore(&video->lock, flags);
>> +		return -EPROTO;
>> +	}
>> +
>> +	set_bit(VIDEO_FRAME_INPRG, &video->flags);
>> +	addr = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
>> +	spin_unlock_irqrestore(&video->lock, flags);
>> +
>> +	aspeed_video_write(video, VE_COMP_PROC_OFFSET, 0);
>> +	aspeed_video_write(video, VE_COMP_OFFSET, 0);
>> +	aspeed_video_write(video, VE_COMP_ADDR, addr);
>> +
>> +	aspeed_video_update(video, VE_INTERRUPT_CTRL, 0xffffffff,
>> +			    VE_INTERRUPT_COMP_COMPLETE |
>> +			    VE_INTERRUPT_CAPTURE_COMPLETE);
>> +
>> +	aspeed_video_update(video, VE_SEQ_CTRL, 0xffffffff,
>> +			    VE_SEQ_CTRL_TRIG_CAPTURE | VE_SEQ_CTRL_TRIG_COMP);
>> +
>> +	return 0;
>> +}
>> +
>> +static void aspeed_video_start_mode_detect(struct aspeed_video *video)
>> +{
>> +	/* Enable mode detect interrupts */
>> +	aspeed_video_update(video, VE_INTERRUPT_CTRL, 0xffffffff,
>> +			    VE_INTERRUPT_MODE_DETECT);
>> +
>> +	/* Trigger mode detect */
>> +	aspeed_video_update(video, VE_SEQ_CTRL, 0xffffffff,
>> +			    VE_SEQ_CTRL_TRIG_MODE_DET);
>> +}
>> +
>> +static void aspeed_video_disable_mode_detect(struct aspeed_video *video)
>> +{
>> +	/* Disable mode detect interrupts */
>> +	aspeed_video_update(video, VE_INTERRUPT_CTRL,
>> +			    ~VE_INTERRUPT_MODE_DETECT, 0);
>> +
>> +	/* Disable mode detect */
>> +	aspeed_video_update(video, VE_SEQ_CTRL, ~VE_SEQ_CTRL_TRIG_MODE_DET, 0);
>> +}
>> +
>> +static void aspeed_video_off(struct aspeed_video *video)
>> +{
>> +	/* Reset the engine */
>> +	reset_control_assert(video->rst);
>> +	udelay(100);
>> +	reset_control_deassert(video->rst);
>> +
>> +	/* Turn off the relevant clocks */
>> +	clk_disable_unprepare(video->vclk);
>> +	clk_disable_unprepare(video->eclk);
>> +}
>> +
>> +static void aspeed_video_on(struct aspeed_video *video)
>> +{
>> +	/* Turn on the relevant clocks */
>> +	clk_prepare_enable(video->eclk);
>> +	clk_prepare_enable(video->vclk);
>> +
>> +	/* Reset the engine */
>> +	reset_control_assert(video->rst);
>> +	udelay(100);
>> +	reset_control_deassert(video->rst);
>> +}
>> +
>> +static void aspeed_video_buf_err(struct aspeed_video *video)
>> +{
>> +	unsigned long flags;
>> +	struct aspeed_video_buffer *buf;
>> +
>> +	spin_lock_irqsave(&video->lock, flags);
>> +	list_for_each_entry(buf, &video->buffers, link) {
>> +		if (list_is_last(&buf->link, &video->buffers))
>> +			buf->vb.flags |= V4L2_BUF_FLAG_LAST;
> There is no need to set the LAST flag. That's meant for MPEG/H264/etc codecs
> and it is not needed for MJPEG.

Ah, I did actually need this for my streaming application to work 
properly. In an error condition, my dequeue call waited forever unless I 
set this flag... The other option was to set the videobuf queue error 
state, but then that isn't recoverable as far as I could tell.

>
>> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> See my comment in start_streaming: VB2_BUF_STATE_ERROR should be an argument to
> this function.
>
>> +	}
>> +	INIT_LIST_HEAD(&video->buffers);
>> +	spin_unlock_irqrestore(&video->lock, flags);
>> +}
>> +
>> +static irqreturn_t aspeed_video_irq(int irq, void *arg)
>> +{
>> +	struct aspeed_video *video = arg;
>> +	u32 sts = aspeed_video_read(video, VE_INTERRUPT_STATUS);
>> +
>> +	if (atomic_read(&video->clients) == 0) {
>> +		dev_info(video->dev, "irq with no client; disabling irqs\n");
>> +
>> +		aspeed_video_write(video, VE_INTERRUPT_CTRL, 0);
>> +		aspeed_video_write(video, VE_INTERRUPT_STATUS, 0xffffffff);
>> +		return IRQ_HANDLED;
>> +	}
>> +
>> +	/* Resolution changed; reset entire engine and reinitialize */
>> +	if (sts & VE_INTERRUPT_MODE_DETECT_WD) {
>> +		dev_info(video->dev, "resolution changed; resetting\n");
>> +		set_bit(VIDEO_RES_CHANGE, &video->flags);
>> +		clear_bit(VIDEO_FRAME_INPRG, &video->flags);
>> +
>> +		aspeed_video_off(video);
>> +		aspeed_video_buf_err(video);
>> +
>> +		schedule_delayed_work(&video->res_work,
>> +				      RESOLUTION_CHANGE_DELAY);
>> +		return IRQ_HANDLED;
>> +	}
>> +
>> +	if (sts & VE_INTERRUPT_MODE_DETECT) {
>> +		aspeed_video_update(video, VE_INTERRUPT_CTRL,
>> +				    ~VE_INTERRUPT_MODE_DETECT, 0);
>> +		aspeed_video_write(video, VE_INTERRUPT_STATUS,
>> +				   VE_INTERRUPT_MODE_DETECT);
>> +
>> +		set_bit(VIDEO_MODE_DETECT_DONE, &video->flags);
>> +		wake_up_interruptible_all(&video->wait);
>> +	}
>> +
>> +	if ((sts & VE_INTERRUPT_COMP_COMPLETE) &&
>> +	    (sts & VE_INTERRUPT_CAPTURE_COMPLETE)) {
>> +		struct aspeed_video_buffer *buf;
>> +		u32 frame_size = aspeed_video_read(video,
>> +						   VE_OFFSET_COMP_STREAM);
>> +
>> +		spin_lock(&video->lock);
>> +		clear_bit(VIDEO_FRAME_INPRG, &video->flags);
>> +		buf = list_first_entry_or_null(&video->buffers,
>> +					       struct aspeed_video_buffer,
>> +					       link);
>> +		if (buf) {
>> +			vb2_set_plane_payload(&buf->vb.vb2_buf, 0, frame_size);
>> +
>> +			if (!list_is_last(&buf->link, &video->buffers)) {
>> +				buf->vb.vb2_buf.timestamp = ktime_get_ns();
>> +				buf->vb.sequence = video->sequence++;
>> +				buf->vb.field = V4L2_FIELD_NONE;
>> +				vb2_buffer_done(&buf->vb.vb2_buf,
>> +						VB2_BUF_STATE_DONE);
>> +				list_del(&buf->link);
>> +			}
>> +		}
>> +		spin_unlock(&video->lock);
>> +
>> +		aspeed_video_update(video, VE_SEQ_CTRL,
>> +				    ~(VE_SEQ_CTRL_TRIG_CAPTURE |
>> +				      VE_SEQ_CTRL_FORCE_IDLE |
>> +				      VE_SEQ_CTRL_TRIG_COMP), 0);
>> +		aspeed_video_update(video, VE_INTERRUPT_CTRL,
>> +				    ~(VE_INTERRUPT_COMP_COMPLETE |
>> +				      VE_INTERRUPT_CAPTURE_COMPLETE), 0);
>> +		aspeed_video_write(video, VE_INTERRUPT_STATUS,
>> +				   VE_INTERRUPT_COMP_COMPLETE |
>> +				   VE_INTERRUPT_CAPTURE_COMPLETE);
>> +
>> +		if (test_bit(VIDEO_STREAMING, &video->flags) && buf)
>> +			aspeed_video_start_frame(video);
>> +	}
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static void aspeed_video_check_polarity(struct aspeed_video *video)
>> +{
>> +	int i;
>> +	int hsync_counter = 0;
>> +	int vsync_counter = 0;
>> +	u32 sts;
>> +
>> +	for (i = 0; i < NUM_POLARITY_CHECKS; ++i) {
>> +		sts = aspeed_video_read(video, VE_MODE_DETECT_STATUS);
>> +		if (sts & VE_MODE_DETECT_STATUS_VSYNC)
>> +			vsync_counter--;
>> +		else
>> +			vsync_counter++;
>> +
>> +		if (sts & VE_MODE_DETECT_STATUS_HSYNC)
>> +			hsync_counter--;
>> +		else
>> +			hsync_counter++;
>> +	}
>> +
>> +	if (hsync_counter < 0 || vsync_counter < 0) {
>> +		u32 ctrl;
>> +
>> +		if (hsync_counter < 0)
>> +			ctrl = VE_CTRL_HSYNC_POL;
>> +
>> +		if (vsync_counter < 0)
>> +			ctrl = VE_CTRL_VSYNC_POL;
>> +
>> +		aspeed_video_update(video, VE_CTRL, 0xffffffff, ctrl);
>> +	}
> If you can read this information, then it would be nice to return it
> in QUERY_DV_TIMINGS.
>
>> +}
>> +
>> +static bool aspeed_video_alloc_buf(struct aspeed_video *video,
>> +				   struct aspeed_video_addr *addr,
>> +				   unsigned int size)
>> +{
>> +	addr->virt = dma_alloc_coherent(video->dev, size, &addr->dma,
>> +					GFP_KERNEL);
>> +	if (!addr->virt)
>> +		return false;
>> +
>> +	addr->size = size;
>> +	return true;
>> +}
>> +
>> +static void aspeed_video_free_buf(struct aspeed_video *video,
>> +				  struct aspeed_video_addr *addr)
>> +{
>> +	dma_free_coherent(video->dev, addr->size, addr->virt, addr->dma);
>> +	addr->size = 0;
>> +	addr->dma = 0ULL;
>> +	addr->virt = NULL;
>> +}
>> +
>> +/*
>> + * Get the minimum HW-supported compression buffer size for the frame size.
>> + * Assume worst-case JPEG compression size is 1/8 raw size. This should be
>> + * plenty even for maximum quality; any worse and the engine will simply return
>> + * incomplete JPEGs.
>> + */
> Ah, nice that you could figure out how the compression algorithm worked.
>
>> +static void aspeed_video_calc_compressed_size(struct aspeed_video *video)
>> +{
>> +	int i, j;
>> +	u32 compression_buffer_size_reg = 0;
>> +	unsigned int size;
>> +	const unsigned int num_compression_packets = 4;
>> +	const unsigned int compression_packet_size = 1024;
>> +	const unsigned int max_compressed_size =
>> +		video->width * video->height / 2;	/* 4 Bpp / 8 */
>> +
>> +	video->max_compressed_size = UINT_MAX;
>> +
>> +	for (i = 0; i < 6; ++i) {
>> +		for (j = 0; j < 8; ++j) {
>> +			size = (num_compression_packets << i) *
>> +				(compression_packet_size << j);
>> +			if (size < max_compressed_size)
>> +				continue;
>> +
>> +			if (size < video->max_compressed_size) {
>> +				compression_buffer_size_reg = (i << 3) | j;
>> +				video->max_compressed_size = size;
>> +			}
>> +		}
>> +	}
>> +
>> +	aspeed_video_write(video, VE_STREAM_BUF_SIZE,
>> +			   compression_buffer_size_reg);
>> +
>> +	dev_dbg(video->dev, "max compressed size: %x\n",
>> +		video->max_compressed_size);
>> +}
>> +
>> +#define res_check(v) test_and_clear_bit(VIDEO_MODE_DETECT_DONE, &(v)->flags)
>> +
>> +static int aspeed_video_get_resolution(struct aspeed_video *video)
>> +{
>> +	bool invalid_resolution = true;
>> +	int rc;
>> +	int tries = 0;
>> +	unsigned int bottom;
>> +	unsigned int left;
>> +	unsigned int right;
>> +	unsigned int size;
>> +	unsigned int top;
>> +	u32 src_lr_edge;
>> +	u32 src_tb_edge;
>> +	struct aspeed_video_addr src;
>> +
>> +	if (video->srcs[1].size)
>> +		aspeed_video_free_buf(video, &video->srcs[1]);
>> +
>> +	if (video->srcs[0].size >= VE_MAX_SRC_BUFFER_SIZE) {
>> +		src = video->srcs[0];
>> +	} else {
>> +		if (video->srcs[0].size)
>> +			aspeed_video_free_buf(video, &video->srcs[0]);
>> +
>> +		if (!aspeed_video_alloc_buf(video, &src,
>> +					    VE_MAX_SRC_BUFFER_SIZE))
>> +			goto err_mem;
>> +	}
>> +
>> +	aspeed_video_write(video, VE_SRC0_ADDR, src.dma);
>> +
>> +	video->width = 0;
>> +	video->height = 0;
>> +
>> +	do {
>> +		if (tries) {
>> +			set_current_state(TASK_INTERRUPTIBLE);
>> +			if (schedule_timeout(INVALID_RESOLUTION_DELAY))
>> +				return -EINTR;
>> +		}
>> +
>> +		aspeed_video_start_mode_detect(video);
>> +
>> +		rc = wait_event_interruptible_timeout(video->wait,
>> +						      res_check(video),
>> +						      MODE_DETECT_TIMEOUT);
>> +		if (!rc) {
>> +			dev_err(video->dev, "timed out on 1st mode detect\n");
>> +			aspeed_video_disable_mode_detect(video);
>> +			return -ETIME;
> That should be ETIMEDOUT.
>
>> +		}
>> +
>> +		/* Disable mode detect in order to re-trigger */
>> +		aspeed_video_update(video, VE_SEQ_CTRL,
>> +				    ~VE_SEQ_CTRL_TRIG_MODE_DET, 0);
>> +
>> +		aspeed_video_check_polarity(video);
>> +
>> +		aspeed_video_start_mode_detect(video);
>> +
>> +		rc = wait_event_interruptible_timeout(video->wait,
>> +						      res_check(video),
>> +						      MODE_DETECT_TIMEOUT);
>> +		if (!rc) {
>> +			dev_err(video->dev, "timed out on 2nd mode detect\n");
>> +			aspeed_video_disable_mode_detect(video);
>> +			return -ETIME;
> Ditto.
>
>> +		}
>> +
>> +		src_lr_edge = aspeed_video_read(video, VE_SRC_LR_EDGE_DET);
>> +		src_tb_edge = aspeed_video_read(video, VE_SRC_TB_EDGE_DET);
>> +
>> +		bottom = (src_tb_edge & VE_SRC_TB_EDGE_DET_BOT) >>
>> +			VE_SRC_TB_EDGE_DET_BOT_SHF;
>> +		top = src_tb_edge & VE_SRC_TB_EDGE_DET_TOP;
>> +		if (top > bottom)
>> +			continue;
>> +
>> +		right = (src_lr_edge & VE_SRC_LR_EDGE_DET_RT) >>
>> +			VE_SRC_LR_EDGE_DET_RT_SHF;
>> +		left = src_lr_edge & VE_SRC_LR_EDGE_DET_LEFT;
>> +		if (left > right)
>> +			continue;
>> +
>> +		invalid_resolution = false;
>> +	} while (invalid_resolution && (tries++ < INVALID_RESOLUTION_RETRIES));
>> +
>> +	if (invalid_resolution) {
>> +		dev_err(video->dev, "invalid resolution detected\n");
>> +		return -EMSGSIZE;
> Hmm, weird error.
>
> Check https://hverkuil.home.xs4all.nl/spec/uapi/v4l/vidioc-query-dv-timings.html
> for common error codes that relate to this.

Thanks!

>
> Note that ENUMINPUT also returns status information.
>
>> +	}
>> +
>> +	video->height = (bottom - top) + 1;
>> +	video->width = (right - left) + 1;
>> +	size = video->height * video->width;
> It looks like you can actually determine the blanking width/height and
> possibly even more detailed information that would be very useful to
> show with the DV_TIMINGS ioctls.
>
>> +
>> +	/* Don't use direct mode below 1024 x 768 (irqs don't fire) */
>> +	if (size < DIRECT_FETCH_THRESHOLD) {
>> +		aspeed_video_write(video, VE_TGS_0,
>> +				   FIELD_PREP(VE_TGS_FIRST, left - 1) |
>> +				   FIELD_PREP(VE_TGS_LAST, right));
>> +		aspeed_video_write(video, VE_TGS_1,
>> +				   FIELD_PREP(VE_TGS_FIRST, top) |
>> +				   FIELD_PREP(VE_TGS_LAST, bottom + 1));
>> +		aspeed_video_update(video, VE_CTRL, 0xffffffff,
>> +				    VE_CTRL_INT_DE);
>> +	} else {
>> +		aspeed_video_update(video, VE_CTRL, 0xffffffff,
>> +				    VE_CTRL_DIRECT_FETCH);
>> +	}
>> +
>> +	aspeed_video_write(video, VE_CAP_WINDOW,
>> +			   video->width << 16 | video->height);
>> +	aspeed_video_write(video, VE_COMP_WINDOW,
>> +			   video->width << 16 | video->height);
>> +	aspeed_video_write(video, VE_SRC_SCANLINE_OFFSET, video->width * 4);
>> +
>> +	aspeed_video_update(video, VE_INTERRUPT_CTRL, 0xffffffff,
>> +			    VE_INTERRUPT_MODE_DETECT_WD);
>> +	aspeed_video_update(video, VE_SEQ_CTRL, 0xffffffff,
>> +			    VE_SEQ_CTRL_AUTO_COMP | VE_SEQ_CTRL_EN_WATCHDOG);
>> +
>> +	dev_dbg(video->dev, "got resolution[%dx%d]\n", video->width,
>> +		video->height);
>> +
>> +	size *= 4;
>> +	if (size == src.size / 2) {
>> +		aspeed_video_write(video, VE_SRC1_ADDR, src.dma + size);
>> +		video->srcs[0] = src;
>> +	} else if (size == src.size) {
>> +		video->srcs[0] = src;
>> +
>> +		if (!aspeed_video_alloc_buf(video, &video->srcs[1], size))
>> +			goto err_mem;
>> +
>> +		aspeed_video_write(video, VE_SRC1_ADDR, video->srcs[1].dma);
>> +	} else {
>> +		aspeed_video_free_buf(video, &src);
>> +
>> +		if (!aspeed_video_alloc_buf(video, &video->srcs[0], size))
>> +			goto err_mem;
>> +
>> +		if (!aspeed_video_alloc_buf(video, &video->srcs[1], size))
>> +			goto err_mem;
>> +
>> +		aspeed_video_write(video, VE_SRC0_ADDR, video->srcs[0].dma);
>> +		aspeed_video_write(video, VE_SRC1_ADDR, video->srcs[1].dma);
>> +	}
>> +
>> +	aspeed_video_calc_compressed_size(video);
>> +
>> +	return 0;
>> +
>> +err_mem:
>> +	dev_err(video->dev, "failed to allocate source buffers\n");
>> +
>> +	if (video->srcs[0].size)
>> +		aspeed_video_free_buf(video, &video->srcs[0]);
>> +
>> +	return -ENOMEM;
>> +}
>> +
>> +static void aspeed_video_init_regs(struct aspeed_video *video)
>> +{
>> +	u32 comp_ctrl = VE_COMP_CTRL_RSVD |
>> +		FIELD_PREP(VE_COMP_CTRL_DCT_LUM, video->jpeg_quality) |
>> +		FIELD_PREP(VE_COMP_CTRL_DCT_CHR, video->jpeg_quality | 0x10);
>> +	u32 ctrl = VE_CTRL_AUTO_OR_CURSOR;
>> +	u32 seq_ctrl = VE_SEQ_CTRL_JPEG_MODE;
>> +
>> +	if (video->frame_rate)
>> +		ctrl |= FIELD_PREP(VE_CTRL_FRC, video->frame_rate);
>> +
>> +	if (video->yuv420)
>> +		seq_ctrl |= VE_SEQ_CTRL_YUV420;
>> +
>> +	/* Unlock VE registers */
>> +	aspeed_video_write(video, VE_PROTECTION_KEY, VE_PROTECTION_KEY_UNLOCK);
>> +
>> +	/* Disable interrupts */
>> +	aspeed_video_write(video, VE_INTERRUPT_CTRL, 0);
>> +	aspeed_video_write(video, VE_INTERRUPT_STATUS, 0xffffffff);
>> +
>> +	/* Clear the offset */
>> +	aspeed_video_write(video, VE_COMP_PROC_OFFSET, 0);
>> +	aspeed_video_write(video, VE_COMP_OFFSET, 0);
>> +
>> +	aspeed_video_write(video, VE_JPEG_ADDR, video->jpeg.dma);
>> +
>> +	/* Set control registers */
>> +	aspeed_video_write(video, VE_SEQ_CTRL, seq_ctrl);
>> +	aspeed_video_write(video, VE_CTRL, ctrl);
>> +	aspeed_video_write(video, VE_COMP_CTRL, comp_ctrl);
>> +
>> +	/* Don't downscale */
>> +	aspeed_video_write(video, VE_SCALING_FACTOR, 0x10001000);
>> +	aspeed_video_write(video, VE_SCALING_FILTER0, 0x00200000);
>> +	aspeed_video_write(video, VE_SCALING_FILTER1, 0x00200000);
>> +	aspeed_video_write(video, VE_SCALING_FILTER2, 0x00200000);
>> +	aspeed_video_write(video, VE_SCALING_FILTER3, 0x00200000);
>> +
>> +	/* Set mode detection defaults */
>> +	aspeed_video_write(video, VE_MODE_DETECT, 0x22666500);
>> +}
>> +
>> +static int aspeed_video_start(struct aspeed_video *video)
>> +{
>> +	int rc;
>> +
>> +	aspeed_video_on(video);
>> +
>> +	aspeed_video_init_regs(video);
>> +
>> +	rc = aspeed_video_get_resolution(video);
>> +	if (rc)
>> +		return rc;
>> +
>> +	video->v4l2_fmt.width = video->width;
>> +	video->v4l2_fmt.height = video->height;
>> +	video->v4l2_fmt.sizeimage = video->max_compressed_size;
>> +
>> +	return 0;
>> +}
>> +
>> +static void aspeed_video_stop(struct aspeed_video *video)
>> +{
>> +	cancel_delayed_work_sync(&video->res_work);
>> +
>> +	aspeed_video_off(video);
>> +
>> +	if (video->srcs[0].size)
>> +		aspeed_video_free_buf(video, &video->srcs[0]);
>> +
>> +	if (video->srcs[1].size)
>> +		aspeed_video_free_buf(video, &video->srcs[1]);
>> +
>> +	video->flags = 0;
>> +}
>> +
>> +static int aspeed_video_querycap(struct file *file, void *fh,
>> +				 struct v4l2_capability *cap)
>> +{
>> +	strscpy(cap->driver, DEVICE_NAME, sizeof(cap->driver));
>> +	strscpy(cap->card, "Aspeed Video Engine", sizeof(cap->card));
>> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
>> +		 DEVICE_NAME);
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_enum_format(struct file *file, void *fh,
>> +				    struct v4l2_fmtdesc *f)
>> +{
>> +	if (f->index)
>> +		return -EINVAL;
>> +
>> +	f->pixelformat = V4L2_PIX_FMT_JPEG;
>> +	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> No need to set the type, it's already checked in the core.
>
>> +	f->flags = V4L2_FMT_FLAG_COMPRESSED;
> No need to set this flag, it will be set for you.
>
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_get_format(struct file *file, void *fh,
>> +				   struct v4l2_format *f)
>> +{
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> No need to set type.
>
>> +	f->fmt.pix = video->v4l2_fmt;
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_enum_input(struct file *file, void *fh,
>> +				   struct v4l2_input *inp)
>> +{
>> +	if (inp->index)
>> +		return -EINVAL;
>> +
>> +	strscpy(inp->name, "Host VGA capture", sizeof(inp->name));
>> +	inp->type = V4L2_INPUT_TYPE_CAMERA;
>> +	inp->capabilities = V4L2_IN_CAP_DV_TIMINGS;
> Update status information. Typically V4L2_IN_ST_NO_SIGNAL is set and V4L2_IN_ST_NO_SYNC.
>
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_get_input(struct file *file, void *fh, unsigned int *i)
>> +{
>> +	*i = 0;
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_set_input(struct file *file, void *fh, unsigned int i)
>> +{
>> +	if (i)
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_get_parm(struct file *file, void *fh,
>> +				 struct v4l2_streamparm *a)
>> +{
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	a->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
>> +	a->parm.capture.readbuffers = 3;
>> +	a->parm.capture.timeperframe.numerator = 1;
>> +	if (!video->frame_rate)
>> +		a->parm.capture.timeperframe.denominator = MAX_FRAME_RATE + 1;
>> +	else
>> +		a->parm.capture.timeperframe.denominator = video->frame_rate;
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_set_parm(struct file *file, void *fh,
>> +				 struct v4l2_streamparm *a)
>> +{
>> +	unsigned int frame_rate = 0;
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	a->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
>> +	a->parm.capture.readbuffers = 3;
>> +
>> +	if (a->parm.capture.timeperframe.numerator)
>> +		frame_rate = a->parm.capture.timeperframe.denominator /
>> +			a->parm.capture.timeperframe.numerator;
>> +
>> +	if (!frame_rate || frame_rate > MAX_FRAME_RATE) {
>> +		frame_rate = 0;
>> +
>> +		/*
>> +		 * Set to max + 1 to differentiate between max and 0, which
>> +		 * means "don't care".
>> +		 */
>> +		a->parm.capture.timeperframe.denominator = MAX_FRAME_RATE + 1;
>> +		a->parm.capture.timeperframe.numerator = 1;
>> +	}
>> +
>> +	if (video->frame_rate != frame_rate) {
>> +		video->frame_rate = frame_rate;
>> +		aspeed_video_update(video, VE_CTRL, ~VE_CTRL_FRC,
>> +				    FIELD_PREP(VE_CTRL_FRC, frame_rate));
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_enum_framesizes(struct file *file, void *fh,
>> +					struct v4l2_frmsizeenum *fsize)
>> +{
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	if (fsize->pixel_format != V4L2_PIX_FMT_JPEG)
>> +		return -EINVAL;
>> +
>> +	switch (fsize->index) {
>> +	case 0:
>> +		fsize->discrete.width = video->v4l2_fmt.width;
>> +		fsize->discrete.height = video->v4l2_fmt.height;
>> +		break;
>> +	case 1:
>> +		if (video->width == video->v4l2_fmt.width &&
>> +		    video->height == video->v4l2_fmt.height)
>> +			return -EINVAL;
>> +
>> +		fsize->discrete.width = video->width;
>> +		fsize->discrete.height = video->height;
> This looks weird. What's the reason for this case 1?

I suppose this is leftover from my incorrect implementation of get/set 
format, as I wanted the detected size to be enumerated if it wasn't the 
one that was set. I can probably drop it.

>
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_enum_frameintervals(struct file *file, void *fh,
>> +					    struct v4l2_frmivalenum *fival)
>> +{
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	if (fival->index)
>> +		return -EINVAL;
>> +
>> +	if (fival->width != video->width || fival->height != video->height)
>> +		return -EINVAL;
>> +
>> +	if (fival->pixel_format != V4L2_PIX_FMT_JPEG)
>> +		return -EINVAL;
>> +
>> +	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
>> +
>> +	fival->stepwise.min.denominator = MAX_FRAME_RATE;
>> +	fival->stepwise.min.numerator = 1;
>> +	fival->stepwise.max.denominator = 1;
>> +	fival->stepwise.max.numerator = 1;
>> +	fival->stepwise.step = fival->stepwise.max;
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_set_dv_timings(struct file *file, void *fh,
>> +				       struct v4l2_dv_timings *timings)
>> +{
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	if (video->width != timings->bt.width ||
>> +	    video->height != timings->bt.height)
>> +		return -EINVAL;
>> +
>> +	video->v4l2_fmt.width = timings->bt.width;
>> +	video->v4l2_fmt.height = timings->bt.height;
>> +	video->v4l2_fmt.sizeimage = video->max_compressed_size;
>> +
>> +	timings->type = V4L2_DV_BT_656_1120;
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_get_dv_timings(struct file *file, void *fh,
>> +				       struct v4l2_dv_timings *timings)
>> +{
>> +	int rc;
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	if (file->f_flags & O_NONBLOCK) {
>> +		if (test_bit(VIDEO_RES_CHANGE, &video->flags))
>> +			return -EAGAIN;
>> +	} else {
>> +		rc = wait_event_interruptible(video->wait,
>> +					      !test_bit(VIDEO_RES_CHANGE,
>> +							&video->flags));
>> +		if (rc)
>> +			return -EINTR;
>> +	}
> This is wrong. get_dv_timings should return what set_dv_timings set,
> regardless of what the actual detected timings are.
>
> What you are actually implementing here is query_dv_timings :-)

OK, understood. Just to clarify, the correct order of operations during 
a detected frame size change would be:

driver sets V4L2_EVENT_SOURCE_CHANGE
application calls query_dv_timings
application calls set_dv_timings to actually change the stored pix format?

>
>> +
>> +	memset(timings, 0, sizeof(*timings));
>> +
>> +	timings->type = V4L2_DV_BT_656_1120;
>> +	timings->bt.width = video->width;
>> +	timings->bt.height = video->height;
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_enum_dv_timings(struct file *file, void *fh,
>> +					struct v4l2_enum_dv_timings *timings)
>> +{
>> +	if (timings->index)
>> +		return -EINVAL;
>> +
>> +	return aspeed_video_get_dv_timings(file, fh, &timings->timings);
>> +}
>> +
>> +static int aspeed_video_dv_timings_cap(struct file *file, void *fh,
>> +				       struct v4l2_dv_timings_cap *cap)
>> +{
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	cap->type = V4L2_DV_BT_656_1120;
>> +	cap->bt.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE;
>> +	cap->bt.min_width = video->width;
>> +	cap->bt.max_width = video->width;
>> +	cap->bt.min_height = video->height;
>> +	cap->bt.max_height = video->height;
>> +
>> +	return 0;
>> +}
> Hmm. I need to think about enum_dv_timings and dv_timings_cap a bit more. This is
> a somewhat odd situation and it needs some thought to decide what these functions
> should do.
>
>> +
>> +static int aspeed_video_sub_event(struct v4l2_fh *fh,
>> +				  const struct v4l2_event_subscription *sub)
>> +{
>> +	switch (sub->type) {
>> +	case V4L2_EVENT_SOURCE_CHANGE:
>> +		return v4l2_src_change_event_subscribe(fh, sub);
>> +	}
>> +
>> +	return v4l2_ctrl_subscribe_event(fh, sub);
>> +}
>> +
>> +static const struct v4l2_ioctl_ops aspeed_video_ioctl_ops = {
>> +	.vidioc_querycap = aspeed_video_querycap,
>> +
>> +	.vidioc_enum_fmt_vid_cap = aspeed_video_enum_format,
>> +	.vidioc_g_fmt_vid_cap = aspeed_video_get_format,
>> +	.vidioc_s_fmt_vid_cap = aspeed_video_get_format,
>> +	.vidioc_try_fmt_vid_cap = aspeed_video_get_format,
>> +
>> +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
>> +	.vidioc_querybuf = vb2_ioctl_querybuf,
>> +	.vidioc_qbuf = vb2_ioctl_qbuf,
>> +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
>> +	.vidioc_create_bufs = vb2_ioctl_create_bufs,
>> +	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
>> +	.vidioc_streamon = vb2_ioctl_streamon,
>> +	.vidioc_streamoff = vb2_ioctl_streamoff,
>> +
>> +	.vidioc_enum_input = aspeed_video_enum_input,
>> +	.vidioc_g_input = aspeed_video_get_input,
>> +	.vidioc_s_input = aspeed_video_set_input,
>> +
>> +	.vidioc_g_parm = aspeed_video_get_parm,
>> +	.vidioc_s_parm = aspeed_video_set_parm,
>> +	.vidioc_enum_framesizes = aspeed_video_enum_framesizes,
>> +	.vidioc_enum_frameintervals = aspeed_video_enum_frameintervals,
>> +
>> +	.vidioc_s_dv_timings = aspeed_video_set_dv_timings,
>> +	.vidioc_g_dv_timings = aspeed_video_get_dv_timings,
>> +	.vidioc_query_dv_timings = aspeed_video_get_dv_timings,
>> +	.vidioc_enum_dv_timings = aspeed_video_enum_dv_timings,
>> +	.vidioc_dv_timings_cap = aspeed_video_dv_timings_cap,
>> +
>> +	.vidioc_subscribe_event = aspeed_video_sub_event,
>> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>> +};
>> +
>> +static void aspeed_video_update_jpeg_quality(struct aspeed_video *video)
>> +{
>> +	u32 comp_ctrl = FIELD_PREP(VE_COMP_CTRL_DCT_LUM, video->jpeg_quality) |
>> +		FIELD_PREP(VE_COMP_CTRL_DCT_CHR, video->jpeg_quality | 0x10);
>> +
>> +	aspeed_video_update(video, VE_COMP_CTRL,
>> +			    ~(VE_COMP_CTRL_DCT_LUM | VE_COMP_CTRL_DCT_CHR),
>> +			    comp_ctrl);
>> +}
>> +
>> +static void aspeed_video_update_subsampling(struct aspeed_video *video)
>> +{
>> +	if (video->jpeg.virt)
>> +		aspeed_video_init_jpeg_table(video->jpeg.virt, video->yuv420);
>> +
>> +	if (video->yuv420)
>> +		aspeed_video_update(video, VE_SEQ_CTRL, 0xffffffff,
>> +				    VE_SEQ_CTRL_YUV420);
>> +	else
>> +		aspeed_video_update(video, VE_SEQ_CTRL, ~VE_SEQ_CTRL_YUV420,
>> +				    0);
>> +}
>> +
>> +static int aspeed_video_set_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct aspeed_video *video = container_of(ctrl->handler,
>> +						  struct aspeed_video,
>> +						  ctrl_handler);
>> +
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
>> +		if (video->jpeg_quality != ctrl->val) {
> No need to check. This function is only called if the new value if different
> from the old.
>
>> +			video->jpeg_quality = ctrl->val;
>> +			aspeed_video_update_jpeg_quality(video);
>> +		}
>> +		break;
>> +	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
>> +		if (ctrl->val == V4L2_JPEG_CHROMA_SUBSAMPLING_420) {
>> +			video->yuv420 = true;
>> +			aspeed_video_update_subsampling(video);
>> +		} else {
>> +			video->yuv420 = false;
>> +			aspeed_video_update_subsampling(video);
>> +		}
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct v4l2_ctrl_ops aspeed_video_ctrl_ops = {
>> +	.s_ctrl = aspeed_video_set_ctrl,
>> +};
>> +
>> +static void aspeed_video_resolution_work(struct work_struct *work)
>> +{
>> +	int rc;
>> +	struct delayed_work *dwork = to_delayed_work(work);
>> +	struct aspeed_video *video = container_of(dwork, struct aspeed_video,
>> +						  res_work);
>> +
>> +	/* No clients remaining after delay */
>> +	if (atomic_read(&video->clients) == 0)
>> +		goto done;
>> +
>> +	aspeed_video_on(video);
>> +
>> +	aspeed_video_init_regs(video);
>> +
>> +	rc = aspeed_video_get_resolution(video);
>> +	if (rc) {
>> +		dev_err(video->dev,
>> +			"resolution changed; couldn't get new resolution\n");
> You also need to send the event if there is no resolution.
>
> You need to keep track of the current state (found resolution or not) and only
> send this event when you transition from one state to another.

OK, yep that makes sense.

>
>> +	} else {
>> +		static const struct v4l2_event ev = {
>> +			.type = V4L2_EVENT_SOURCE_CHANGE,
>> +			.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
>> +		};
>> +
>> +		v4l2_event_queue(&video->vdev, &ev);
>> +
>> +		if (test_bit(VIDEO_STREAMING, &video->flags))
>> +			aspeed_video_start_frame(video);
>> +	}
>> +
>> +done:
>> +	clear_bit(VIDEO_RES_CHANGE, &video->flags);
>> +	wake_up_interruptible_all(&video->wait);
>> +}
>> +
>> +static int aspeed_video_open(struct file *file)
>> +{
>> +	int rc;
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	if (atomic_inc_return(&video->clients) == 1) {
>> +		rc = aspeed_video_start(video);
>> +		if (rc) {
>> +			dev_err(video->dev, "Failed to start video engine\n");
>> +			atomic_dec(&video->clients);
>> +			return rc;
>> +		}
>> +	}
>> +
>> +	return v4l2_fh_open(file);
>> +}
>> +
>> +static int aspeed_video_release(struct file *file)
>> +{
>> +	int rc;
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	rc = vb2_fop_release(file);
>> +
> You need to lock video->video_lock here. Otherwise an open can occur while
> you are in aspeed_video_stop. You also need to take this lock for the same
> reason in aspeed_video_open above.
>
>> +	if (atomic_dec_return(&video->clients) == 0)
>> +		aspeed_video_stop(video);
>> +
>> +	return rc;
>> +}
>> +
>> +static const struct v4l2_file_operations aspeed_video_v4l2_fops = {
>> +	.owner = THIS_MODULE,
>> +	.read = vb2_fop_read,
>> +	.poll = vb2_fop_poll,
>> +	.unlocked_ioctl = video_ioctl2,
>> +	.mmap = vb2_fop_mmap,
>> +	.open = aspeed_video_open,
>> +	.release = aspeed_video_release,
>> +};
>> +
>> +static int aspeed_video_queue_setup(struct vb2_queue *q,
>> +				    unsigned int *num_buffers,
>> +				    unsigned int *num_planes,
>> +				    unsigned int sizes[],
>> +				    struct device *alloc_devs[])
>> +{
>> +	struct aspeed_video *video = vb2_get_drv_priv(q);
>> +
>> +	if (*num_planes) {
>> +		if (sizes[0] < video->max_compressed_size)
>> +			return -EINVAL;
>> +
>> +		return 0;
>> +	}
>> +
>> +	*num_planes = 1;
>> +	sizes[0] = video->max_compressed_size;
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_buf_prepare(struct vb2_buffer *vb)
>> +{
>> +	struct aspeed_video *video = vb2_get_drv_priv(vb->vb2_queue);
>> +
>> +	if (vb2_plane_size(vb, 0) < video->max_compressed_size)
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_start_streaming(struct vb2_queue *q,
>> +					unsigned int count)
>> +{
>> +	int rc;
>> +	struct aspeed_video *video = vb2_get_drv_priv(q);
>> +
>> +	rc = aspeed_video_start_frame(video);
>> +	if (rc) {
>> +		aspeed_video_buf_err(video);
> If start_streaming fails, then the buffers should be returned to state
> QUEUED, not ERROR. Most drivers have a similar function to aspeed_video_buf_err,
> but the state is an argument.
>
>> +		return rc;
>> +	}
>> +
>> +	video->sequence = 0;
>> +	set_bit(VIDEO_STREAMING, &video->flags);
>> +	return 0;
>> +}
>> +
>> +static void aspeed_video_stop_streaming(struct vb2_queue *q)
>> +{
>> +	int rc;
>> +	struct aspeed_video *video = vb2_get_drv_priv(q);
>> +
>> +	clear_bit(VIDEO_STREAMING, &video->flags);
>> +
>> +	rc = wait_event_timeout(video->wait,
>> +				!test_bit(VIDEO_FRAME_INPRG, &video->flags),
>> +				STOP_TIMEOUT);
>> +	if (!rc) {
>> +		dev_err(video->dev, "Timed out when stopping streaming\n");
>> +		aspeed_video_stop(video);
>> +	}
>> +
>> +	aspeed_video_buf_err(video);
>> +}
>> +
>> +static void aspeed_video_buf_queue(struct vb2_buffer *vb)
>> +{
>> +	unsigned long flags;
> Move this to below the avb declaration.
>
>> +	struct aspeed_video *video = vb2_get_drv_priv(vb->vb2_queue);
>> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>> +	struct aspeed_video_buffer *avb = to_aspeed_video_buffer(vbuf);
>> +
>> +	spin_lock_irqsave(&video->lock, flags);
>> +	list_add_tail(&avb->link, &video->buffers);
>> +	spin_unlock_irqrestore(&video->lock, flags);
>> +}
>> +
>> +static const struct vb2_ops aspeed_video_vb2_ops = {
>> +	.queue_setup = aspeed_video_queue_setup,
>> +	.buf_prepare = aspeed_video_buf_prepare,
>> +	.start_streaming = aspeed_video_start_streaming,
>> +	.stop_streaming = aspeed_video_stop_streaming,
>> +	.buf_queue =  aspeed_video_buf_queue,
> Add this:
>
>          .wait_prepare           = vb2_ops_wait_prepare,
>          .wait_finish            = vb2_ops_wait_finish,
>
> That should fix the streaming v4l2-compliance fail.
>
>> +};
>> +
>> +static int aspeed_video_setup_video(struct aspeed_video *video)
>> +{
>> +	int rc;
> Move this to below the vdev declaration.
>
>> +	u64 mask = ~(BIT(V4L2_JPEG_CHROMA_SUBSAMPLING_444) |
>> +		     BIT(V4L2_JPEG_CHROMA_SUBSAMPLING_420));
> Can be const.
>
>> +	struct v4l2_device *v4l2_dev = &video->v4l2_dev;
>> +	struct vb2_queue *vbq = &video->queue;
>> +	struct video_device *vdev = &video->vdev;
>> +
>> +	video->v4l2_fmt.pixelformat = V4L2_PIX_FMT_JPEG;
>> +	video->v4l2_fmt.field = V4L2_FIELD_NONE;
>> +	video->v4l2_fmt.colorspace = V4L2_COLORSPACE_SRGB;
>> +	video->v4l2_fmt.quantization = V4L2_QUANTIZATION_FULL_RANGE;
>> +
>> +	rc = v4l2_device_register(video->dev, v4l2_dev);
>> +	if (rc) {
>> +		dev_err(video->dev, "Failed to register v4l2 device\n");
>> +		return rc;
>> +	}
>> +
>> +	v4l2_ctrl_handler_init(&video->ctrl_handler, 2);
>> +	v4l2_ctrl_new_std(&video->ctrl_handler, &aspeed_video_ctrl_ops,
>> +			  V4L2_CID_JPEG_COMPRESSION_QUALITY, 0,
>> +			  ASPEED_VIDEO_JPEG_NUM_QUALITIES - 1, 1, 0);
>> +	v4l2_ctrl_new_std_menu(&video->ctrl_handler, &aspeed_video_ctrl_ops,
>> +			       V4L2_CID_JPEG_CHROMA_SUBSAMPLING,
>> +			       V4L2_JPEG_CHROMA_SUBSAMPLING_420, mask,
>> +			       V4L2_JPEG_CHROMA_SUBSAMPLING_444);
>> +
>> +	if (video->ctrl_handler.error) {
>> +		v4l2_ctrl_handler_free(&video->ctrl_handler);
>> +		v4l2_device_unregister(v4l2_dev);
>> +
>> +		dev_err(video->dev, "Failed to init controls: %d\n",
>> +			video->ctrl_handler.error);
>> +		return rc;
>> +	}
>> +
>> +	v4l2_dev->ctrl_handler = &video->ctrl_handler;
>> +	vdev->ctrl_handler = &video->ctrl_handler;
> Not necessary. Setting it in v4l2_dev is sufficient.
>
>> +
>> +	vbq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +	vbq->io_modes = VB2_MMAP | VB2_READ;
> Add VB2_DMABUF.
>
>> +	vbq->dev = v4l2_dev->dev;
>> +	vbq->lock = &video->video_lock;
>> +	vbq->ops = &aspeed_video_vb2_ops;
>> +	vbq->mem_ops = &vb2_dma_contig_memops;
>> +	vbq->drv_priv = video;
>> +	vbq->buf_struct_size = sizeof(struct aspeed_video_buffer);
>> +	vbq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>> +	vbq->min_buffers_needed = 3;
>> +
>> +	rc = vb2_queue_init(vbq);
>> +	if (rc) {
>> +		v4l2_ctrl_handler_free(&video->ctrl_handler);
>> +		v4l2_device_unregister(v4l2_dev);
>> +
>> +		dev_err(video->dev, "Failed to init vb2 queue\n");
>> +		return rc;
>> +	}
>> +
>> +	vdev->queue = vbq;
>> +	vdev->fops = &aspeed_video_v4l2_fops;
>> +	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
>> +		V4L2_CAP_STREAMING;
>> +	vdev->v4l2_dev = v4l2_dev;
>> +	strscpy(vdev->name, DEVICE_NAME, sizeof(vdev->name));
>> +	vdev->vfl_type = VFL_TYPE_GRABBER;
>> +	vdev->vfl_dir = VFL_DIR_RX;
>> +	vdev->release = video_device_release_empty;
>> +	vdev->ioctl_ops = &aspeed_video_ioctl_ops;
>> +	vdev->lock = &video->video_lock;
>> +
>> +	video_set_drvdata(vdev, video);
>> +	rc = video_register_device(vdev, VFL_TYPE_GRABBER, 0);
>> +	if (rc) {
>> +		vb2_queue_release(vbq);
>> +		v4l2_ctrl_handler_free(&video->ctrl_handler);
>> +		v4l2_device_unregister(v4l2_dev);
>> +
>> +		dev_err(video->dev, "Failed to register video device\n");
>> +		return rc;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_init(struct aspeed_video *video)
>> +{
>> +	int irq;
>> +	int rc;
>> +	struct device *dev = video->dev;
>> +
>> +	irq = irq_of_parse_and_map(dev->of_node, 0);
>> +	if (!irq) {
>> +		dev_err(dev, "Unable to find IRQ\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	rc = devm_request_irq(dev, irq, aspeed_video_irq, IRQF_SHARED,
>> +			      DEVICE_NAME, video);
>> +	if (rc < 0) {
>> +		dev_err(dev, "Unable to request IRQ %d\n", irq);
>> +		return rc;
>> +	}
>> +
>> +	video->eclk = devm_clk_get(dev, "eclk");
>> +	if (IS_ERR(video->eclk)) {
>> +		dev_err(dev, "Unable to get ECLK\n");
>> +		return PTR_ERR(video->eclk);
>> +	}
>> +
>> +	video->vclk = devm_clk_get(dev, "vclk");
>> +	if (IS_ERR(video->vclk)) {
>> +		dev_err(dev, "Unable to get VCLK\n");
>> +		return PTR_ERR(video->vclk);
>> +	}
>> +
>> +	video->rst = devm_reset_control_get_exclusive(dev, NULL);
>> +	if (IS_ERR(video->rst)) {
>> +		dev_err(dev, "Unable to get VE reset\n");
>> +		return PTR_ERR(video->rst);
>> +	}
>> +
>> +	rc = of_reserved_mem_device_init(dev);
>> +	if (rc) {
>> +		dev_err(dev, "Unable to reserve memory\n");
>> +		return rc;
>> +	}
>> +
>> +	rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
>> +	if (rc) {
>> +		dev_err(dev, "Failed to set DMA mask\n");
>> +		of_reserved_mem_device_release(dev);
>> +		return rc;
>> +	}
>> +
>> +	if (!aspeed_video_alloc_buf(video, &video->jpeg,
>> +				    VE_JPEG_HEADER_SIZE)) {
>> +		dev_err(dev, "Failed to allocate DMA for JPEG header\n");
>> +		of_reserved_mem_device_release(dev);
>> +		return rc;
>> +	}
>> +
>> +	aspeed_video_init_jpeg_table(video->jpeg.virt, video->yuv420);
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_probe(struct platform_device *pdev)
>> +{
>> +	int rc;
>> +	struct resource *res;
>> +	struct aspeed_video *video = kzalloc(sizeof(*video), GFP_KERNEL);
>> +
>> +	if (!video)
>> +		return -ENOMEM;
>> +
>> +	video->frame_rate = 30;
>> +	video->dev = &pdev->dev;
>> +	mutex_init(&video->video_lock);
>> +	init_waitqueue_head(&video->wait);
>> +	INIT_DELAYED_WORK(&video->res_work, aspeed_video_resolution_work);
>> +	INIT_LIST_HEAD(&video->buffers);
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +
>> +	video->base = devm_ioremap_resource(video->dev, res);
>> +
>> +	if (IS_ERR(video->base))
>> +		return PTR_ERR(video->base);
>> +
>> +	rc = aspeed_video_init(video);
>> +	if (rc)
>> +		return rc;
>> +
>> +	rc = aspeed_video_setup_video(video);
>> +	if (rc)
>> +		return rc;
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_remove(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
>> +	struct aspeed_video *video = to_aspeed_video(v4l2_dev);
>> +
>> +	video_unregister_device(&video->vdev);
>> +
>> +	vb2_queue_release(&video->queue);
>> +
>> +	v4l2_ctrl_handler_free(&video->ctrl_handler);
>> +
>> +	v4l2_device_unregister(v4l2_dev);
>> +
>> +	dma_free_coherent(video->dev, VE_JPEG_HEADER_SIZE, video->jpeg.virt,
>> +			  video->jpeg.dma);
>> +
>> +	of_reserved_mem_device_release(dev);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id aspeed_video_of_match[] = {
>> +	{ .compatible = "aspeed,ast2400-video-engine" },
>> +	{ .compatible = "aspeed,ast2500-video-engine" },
>> +	{}
>> +};
>> +MODULE_DEVICE_TABLE(of, aspeed_video_of_match);
>> +
>> +static struct platform_driver aspeed_video_driver = {
>> +	.driver = {
>> +		.name = DEVICE_NAME,
>> +		.of_match_table = aspeed_video_of_match,
>> +	},
>> +	.probe = aspeed_video_probe,
>> +	.remove = aspeed_video_remove,
>> +};
>> +
>> +module_platform_driver(aspeed_video_driver);
>> +
>> +MODULE_DESCRIPTION("ASPEED Video Engine Driver");
>> +MODULE_AUTHOR("Eddie James");
>> +MODULE_LICENSE("GPL v2");
>>
> Regards,
>
> 	Hans
>
