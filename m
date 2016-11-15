Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:38141 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751359AbcKOQcR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 11:32:17 -0500
Date: Wed, 16 Nov 2016 00:31:50 +0800
From: kbuild test robot <lkp@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] stk-webcam: fix an endian bug in
 stk_camera_read_reg()
Message-ID: <201611160023.qFVhadgL%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <20161115094808.GA15424@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dan,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.9-rc5 next-20161115]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Carpenter/stk-webcam-fix-an-endian-bug-in-stk_camera_read_reg/20161115-213514
base:   git://linuxtv.org/media_tree.git master
config: x86_64-randconfig-s5-11152316 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/mod_devicetable.h:11,
                    from include/linux/usb.h:4,
                    from drivers/media/usb/stkwebcam/stk-webcam.h:25,
                    from drivers/media/usb/stkwebcam/stk-sensor.c:48:
   drivers/media/usb/stkwebcam/stk-sensor.c: In function 'stk_sensor_outb':
   drivers/media/usb/stkwebcam/stk-sensor.c:240:46: error: passing argument 3 of 'stk_camera_read_reg' from incompatible pointer type [-Werror=incompatible-pointer-types]
      if (stk_camera_read_reg(dev, STK_IIC_STAT, &tmpval))
                                                 ^
   include/linux/compiler.h:149:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
>> drivers/media/usb/stkwebcam/stk-sensor.c:240:3: note: in expansion of macro 'if'
      if (stk_camera_read_reg(dev, STK_IIC_STAT, &tmpval))
      ^~
   In file included from drivers/media/usb/stkwebcam/stk-sensor.c:48:0:
   drivers/media/usb/stkwebcam/stk-webcam.h:132:5: note: expected 'u8 * {aka unsigned char *}' but argument is of type 'int *'
    int stk_camera_read_reg(struct stk_camera *, u16, u8 *);
        ^~~~~~~~~~~~~~~~~~~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/mod_devicetable.h:11,
                    from include/linux/usb.h:4,
                    from drivers/media/usb/stkwebcam/stk-webcam.h:25,
                    from drivers/media/usb/stkwebcam/stk-sensor.c:48:
   drivers/media/usb/stkwebcam/stk-sensor.c:240:46: error: passing argument 3 of 'stk_camera_read_reg' from incompatible pointer type [-Werror=incompatible-pointer-types]
      if (stk_camera_read_reg(dev, STK_IIC_STAT, &tmpval))
                                                 ^
   include/linux/compiler.h:149:42: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                             ^~~~
>> drivers/media/usb/stkwebcam/stk-sensor.c:240:3: note: in expansion of macro 'if'
      if (stk_camera_read_reg(dev, STK_IIC_STAT, &tmpval))
      ^~
   In file included from drivers/media/usb/stkwebcam/stk-sensor.c:48:0:
   drivers/media/usb/stkwebcam/stk-webcam.h:132:5: note: expected 'u8 * {aka unsigned char *}' but argument is of type 'int *'
    int stk_camera_read_reg(struct stk_camera *, u16, u8 *);
        ^~~~~~~~~~~~~~~~~~~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/mod_devicetable.h:11,
                    from include/linux/usb.h:4,
                    from drivers/media/usb/stkwebcam/stk-webcam.h:25,
                    from drivers/media/usb/stkwebcam/stk-sensor.c:48:
   drivers/media/usb/stkwebcam/stk-sensor.c:240:46: error: passing argument 3 of 'stk_camera_read_reg' from incompatible pointer type [-Werror=incompatible-pointer-types]
      if (stk_camera_read_reg(dev, STK_IIC_STAT, &tmpval))
                                                 ^
   include/linux/compiler.h:160:16: note: in definition of macro '__trace_if'
      ______r = !!(cond);     \
                   ^~~~
>> drivers/media/usb/stkwebcam/stk-sensor.c:240:3: note: in expansion of macro 'if'
      if (stk_camera_read_reg(dev, STK_IIC_STAT, &tmpval))
      ^~
   In file included from drivers/media/usb/stkwebcam/stk-sensor.c:48:0:
   drivers/media/usb/stkwebcam/stk-webcam.h:132:5: note: expected 'u8 * {aka unsigned char *}' but argument is of type 'int *'
    int stk_camera_read_reg(struct stk_camera *, u16, u8 *);
        ^~~~~~~~~~~~~~~~~~~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/mod_devicetable.h:11,
                    from include/linux/usb.h:4,
                    from drivers/media/usb/stkwebcam/stk-webcam.h:25,
                    from drivers/media/usb/stkwebcam/stk-sensor.c:48:
   drivers/media/usb/stkwebcam/stk-sensor.c: In function 'stk_sensor_inb':
   drivers/media/usb/stkwebcam/stk-sensor.c:263:46: error: passing argument 3 of 'stk_camera_read_reg' from incompatible pointer type [-Werror=incompatible-pointer-types]
      if (stk_camera_read_reg(dev, STK_IIC_STAT, &tmpval))
                                                 ^
   include/linux/compiler.h:149:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
   drivers/media/usb/stkwebcam/stk-sensor.c:263:3: note: in expansion of macro 'if'
      if (stk_camera_read_reg(dev, STK_IIC_STAT, &tmpval))
      ^~
   In file included from drivers/media/usb/stkwebcam/stk-sensor.c:48:0:
   drivers/media/usb/stkwebcam/stk-webcam.h:132:5: note: expected 'u8 * {aka unsigned char *}' but argument is of type 'int *'
    int stk_camera_read_reg(struct stk_camera *, u16, u8 *);
        ^~~~~~~~~~~~~~~~~~~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/mod_devicetable.h:11,
                    from include/linux/usb.h:4,
                    from drivers/media/usb/stkwebcam/stk-webcam.h:25,
                    from drivers/media/usb/stkwebcam/stk-sensor.c:48:
   drivers/media/usb/stkwebcam/stk-sensor.c:263:46: error: passing argument 3 of 'stk_camera_read_reg' from incompatible pointer type [-Werror=incompatible-pointer-types]
      if (stk_camera_read_reg(dev, STK_IIC_STAT, &tmpval))
                                                 ^
   include/linux/compiler.h:149:42: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                             ^~~~
   drivers/media/usb/stkwebcam/stk-sensor.c:263:3: note: in expansion of macro 'if'
      if (stk_camera_read_reg(dev, STK_IIC_STAT, &tmpval))
      ^~
   In file included from drivers/media/usb/stkwebcam/stk-sensor.c:48:0:
   drivers/media/usb/stkwebcam/stk-webcam.h:132:5: note: expected 'u8 * {aka unsigned char *}' but argument is of type 'int *'
    int stk_camera_read_reg(struct stk_camera *, u16, u8 *);
        ^~~~~~~~~~~~~~~~~~~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/mod_devicetable.h:11,
                    from include/linux/usb.h:4,
                    from drivers/media/usb/stkwebcam/stk-webcam.h:25,
                    from drivers/media/usb/stkwebcam/stk-sensor.c:48:
   drivers/media/usb/stkwebcam/stk-sensor.c:263:46: error: passing argument 3 of 'stk_camera_read_reg' from incompatible pointer type [-Werror=incompatible-pointer-types]
      if (stk_camera_read_reg(dev, STK_IIC_STAT, &tmpval))
                                                 ^
   include/linux/compiler.h:160:16: note: in definition of macro '__trace_if'
      ______r = !!(cond);     \
                   ^~~~
   drivers/media/usb/stkwebcam/stk-sensor.c:263:3: note: in expansion of macro 'if'
      if (stk_camera_read_reg(dev, STK_IIC_STAT, &tmpval))
      ^~
   In file included from drivers/media/usb/stkwebcam/stk-sensor.c:48:0:
   drivers/media/usb/stkwebcam/stk-webcam.h:132:5: note: expected 'u8 * {aka unsigned char *}' but argument is of type 'int *'
    int stk_camera_read_reg(struct stk_camera *, u16, u8 *);
        ^~~~~~~~~~~~~~~~~~~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/mod_devicetable.h:11,
                    from include/linux/usb.h:4,
                    from drivers/media/usb/stkwebcam/stk-webcam.h:25,
                    from drivers/media/usb/stkwebcam/stk-sensor.c:48:
   drivers/media/usb/stkwebcam/stk-sensor.c:274:49: error: passing argument 3 of 'stk_camera_read_reg' from incompatible pointer type [-Werror=incompatible-pointer-types]
     if (stk_camera_read_reg(dev, STK_IIC_RX_VALUE, &tmpval))
                                                    ^
   include/linux/compiler.h:149:30: note: in definition of macro '__trace_if'
     if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
                                 ^~~~
   drivers/media/usb/stkwebcam/stk-sensor.c:274:2: note: in expansion of macro 'if'
     if (stk_camera_read_reg(dev, STK_IIC_RX_VALUE, &tmpval))
     ^~
   In file included from drivers/media/usb/stkwebcam/stk-sensor.c:48:0:
   drivers/media/usb/stkwebcam/stk-webcam.h:132:5: note: expected 'u8 * {aka unsigned char *}' but argument is of type 'int *'
    int stk_camera_read_reg(struct stk_camera *, u16, u8 *);
        ^~~~~~~~~~~~~~~~~~~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,

vim +/if +240 drivers/media/usb/stkwebcam/stk-sensor.c

ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   42   *   output 0x0005 to index 0x0200
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   43   *   input 1 byte from index 0x0201 until its value becomes 0x04
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   44   */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   45  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   46  /* It seems the i2c bus is controlled with these registers */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   47  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  @48  #include "stk-webcam.h"
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   49  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   50  #define STK_IIC_BASE		(0x0200)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   51  #  define STK_IIC_OP		(STK_IIC_BASE)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   52  #    define STK_IIC_OP_TX	(0x05)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   53  #    define STK_IIC_OP_RX	(0x70)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   54  #  define STK_IIC_STAT		(STK_IIC_BASE+1)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   55  #    define STK_IIC_STAT_TX_OK	(0x04)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   56  #    define STK_IIC_STAT_RX_OK	(0x01)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   57  /* I don't know what does this register.
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   58   * when it is 0x00 or 0x01, we cannot talk to the sensor,
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   59   * other values work */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   60  #  define STK_IIC_ENABLE	(STK_IIC_BASE+2)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   61  #    define STK_IIC_ENABLE_NO	(0x00)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   62  /* This is what the driver writes in windows */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   63  #    define STK_IIC_ENABLE_YES	(0x1e)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   64  /*
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   65   * Address of the slave. Seems like the binary driver look for the
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   66   * sensor in multiple places, attempting a reset sequence.
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   67   * We only know about the ov9650
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   68   */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   69  #  define STK_IIC_ADDR		(STK_IIC_BASE+3)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   70  #  define STK_IIC_TX_INDEX	(STK_IIC_BASE+4)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   71  #  define STK_IIC_TX_VALUE	(STK_IIC_BASE+5)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   72  #  define STK_IIC_RX_INDEX	(STK_IIC_BASE+8)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   73  #  define STK_IIC_RX_VALUE	(STK_IIC_BASE+9)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   74  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   75  #define MAX_RETRIES		(50)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   76  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   77  #define SENSOR_ADDRESS		(0x60)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   78  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   79  /* From ov7670.c (These registers aren't fully accurate) */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   80  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   81  /* Registers */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   82  #define REG_GAIN	0x00	/* Gain lower 8 bits (rest in vref) */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   83  #define REG_BLUE	0x01	/* blue gain */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   84  #define REG_RED		0x02	/* red gain */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   85  #define REG_VREF	0x03	/* Pieces of GAIN, VSTART, VSTOP */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   86  #define REG_COM1	0x04	/* Control 1 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   87  #define  COM1_CCIR656	  0x40  /* CCIR656 enable */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   88  #define  COM1_QFMT	  0x20  /* QVGA/QCIF format */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   89  #define  COM1_SKIP_0	  0x00  /* Do not skip any row */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   90  #define  COM1_SKIP_2	  0x04  /* Skip 2 rows of 4 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   91  #define  COM1_SKIP_3	  0x08  /* Skip 3 rows of 4 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   92  #define REG_BAVE	0x05	/* U/B Average level */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   93  #define REG_GbAVE	0x06	/* Y/Gb Average level */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   94  #define REG_AECHH	0x07	/* AEC MS 5 bits */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   95  #define REG_RAVE	0x08	/* V/R Average level */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   96  #define REG_COM2	0x09	/* Control 2 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   97  #define  COM2_SSLEEP	  0x10	/* Soft sleep mode */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   98  #define REG_PID		0x0a	/* Product ID MSB */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12   99  #define REG_VER		0x0b	/* Product ID LSB */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  100  #define REG_COM3	0x0c	/* Control 3 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  101  #define  COM3_SWAP	  0x40	  /* Byte swap */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  102  #define  COM3_SCALEEN	  0x08	  /* Enable scaling */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  103  #define  COM3_DCWEN	  0x04	  /* Enable downsamp/crop/window */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  104  #define REG_COM4	0x0d	/* Control 4 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  105  #define REG_COM5	0x0e	/* All "reserved" */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  106  #define REG_COM6	0x0f	/* Control 6 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  107  #define REG_AECH	0x10	/* More bits of AEC value */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  108  #define REG_CLKRC	0x11	/* Clock control */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  109  #define   CLK_PLL	  0x80	  /* Enable internal PLL */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  110  #define   CLK_EXT	  0x40	  /* Use external clock directly */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  111  #define   CLK_SCALE	  0x3f	  /* Mask for internal clock scale */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  112  #define REG_COM7	0x12	/* Control 7 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  113  #define   COM7_RESET	  0x80	  /* Register reset */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  114  #define   COM7_FMT_MASK	  0x38
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  115  #define   COM7_FMT_SXGA	  0x00
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  116  #define   COM7_FMT_VGA	  0x40
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  117  #define	  COM7_FMT_CIF	  0x20	  /* CIF format */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  118  #define   COM7_FMT_QVGA	  0x10	  /* QVGA format */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  119  #define   COM7_FMT_QCIF	  0x08	  /* QCIF format */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  120  #define	  COM7_RGB	  0x04	  /* bits 0 and 2 - RGB format */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  121  #define	  COM7_YUV	  0x00	  /* YUV */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  122  #define	  COM7_BAYER	  0x01	  /* Bayer format */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  123  #define	  COM7_PBAYER	  0x05	  /* "Processed bayer" */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  124  #define REG_COM8	0x13	/* Control 8 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  125  #define   COM8_FASTAEC	  0x80	  /* Enable fast AGC/AEC */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  126  #define   COM8_AECSTEP	  0x40	  /* Unlimited AEC step size */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  127  #define   COM8_BFILT	  0x20	  /* Band filter enable */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  128  #define   COM8_AGC	  0x04	  /* Auto gain enable */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  129  #define   COM8_AWB	  0x02	  /* White balance enable */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  130  #define   COM8_AEC	  0x01	  /* Auto exposure enable */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  131  #define REG_COM9	0x14	/* Control 9  - gain ceiling */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  132  #define REG_COM10	0x15	/* Control 10 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  133  #define   COM10_HSYNC	  0x40	  /* HSYNC instead of HREF */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  134  #define   COM10_PCLK_HB	  0x20	  /* Suppress PCLK on horiz blank */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  135  #define   COM10_HREF_REV  0x08	  /* Reverse HREF */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  136  #define   COM10_VS_LEAD	  0x04	  /* VSYNC on clock leading edge */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  137  #define   COM10_VS_NEG	  0x02	  /* VSYNC negative */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  138  #define   COM10_HS_NEG	  0x01	  /* HSYNC negative */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  139  #define REG_HSTART	0x17	/* Horiz start high bits */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  140  #define REG_HSTOP	0x18	/* Horiz stop high bits */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  141  #define REG_VSTART	0x19	/* Vert start high bits */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  142  #define REG_VSTOP	0x1a	/* Vert stop high bits */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  143  #define REG_PSHFT	0x1b	/* Pixel delay after HREF */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  144  #define REG_MIDH	0x1c	/* Manuf. ID high */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  145  #define REG_MIDL	0x1d	/* Manuf. ID low */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  146  #define REG_MVFP	0x1e	/* Mirror / vflip */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  147  #define   MVFP_MIRROR	  0x20	  /* Mirror image */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  148  #define   MVFP_FLIP	  0x10	  /* Vertical flip */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  149  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  150  #define REG_AEW		0x24	/* AGC upper limit */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  151  #define REG_AEB		0x25	/* AGC lower limit */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  152  #define REG_VPT		0x26	/* AGC/AEC fast mode op region */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  153  #define REG_ADVFL	0x2d	/* Insert dummy lines (LSB) */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  154  #define REG_ADVFH	0x2e	/* Insert dummy lines (MSB) */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  155  #define REG_HSYST	0x30	/* HSYNC rising edge delay */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  156  #define REG_HSYEN	0x31	/* HSYNC falling edge delay */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  157  #define REG_HREF	0x32	/* HREF pieces */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  158  #define REG_TSLB	0x3a	/* lots of stuff */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  159  #define   TSLB_YLAST	  0x04	  /* UYVY or VYUY - see com13 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  160  #define   TSLB_BYTEORD	  0x08	  /* swap bytes in 16bit mode? */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  161  #define REG_COM11	0x3b	/* Control 11 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  162  #define   COM11_NIGHT	  0x80	  /* NIght mode enable */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  163  #define   COM11_NMFR	  0x60	  /* Two bit NM frame rate */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  164  #define   COM11_HZAUTO	  0x10	  /* Auto detect 50/60 Hz */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  165  #define	  COM11_50HZ	  0x08	  /* Manual 50Hz select */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  166  #define   COM11_EXP	  0x02
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  167  #define REG_COM12	0x3c	/* Control 12 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  168  #define   COM12_HREF	  0x80	  /* HREF always */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  169  #define REG_COM13	0x3d	/* Control 13 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  170  #define   COM13_GAMMA	  0x80	  /* Gamma enable */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  171  #define	  COM13_UVSAT	  0x40	  /* UV saturation auto adjustment */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  172  #define	  COM13_CMATRIX	  0x10	  /* Enable color matrix for RGB or YUV */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  173  #define   COM13_UVSWAP	  0x01	  /* V before U - w/TSLB */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  174  #define REG_COM14	0x3e	/* Control 14 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  175  #define   COM14_DCWEN	  0x10	  /* DCW/PCLK-scale enable */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  176  #define REG_EDGE	0x3f	/* Edge enhancement factor */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  177  #define REG_COM15	0x40	/* Control 15 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  178  #define   COM15_R10F0	  0x00	  /* Data range 10 to F0 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  179  #define	  COM15_R01FE	  0x80	  /*            01 to FE */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  180  #define   COM15_R00FF	  0xc0	  /*            00 to FF */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  181  #define   COM15_RGB565	  0x10	  /* RGB565 output */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  182  #define   COM15_RGBFIXME	  0x20	  /* FIXME  */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  183  #define   COM15_RGB555	  0x30	  /* RGB555 output */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  184  #define REG_COM16	0x41	/* Control 16 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  185  #define   COM16_AWBGAIN   0x08	  /* AWB gain enable */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  186  #define REG_COM17	0x42	/* Control 17 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  187  #define   COM17_AECWIN	  0xc0	  /* AEC window - must match COM4 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  188  #define   COM17_CBAR	  0x08	  /* DSP Color bar */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  189  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  190  /*
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  191   * This matrix defines how the colors are generated, must be
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  192   * tweaked to adjust hue and saturation.
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  193   *
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  194   * Order: v-red, v-green, v-blue, u-red, u-green, u-blue
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  195   *
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  196   * They are nine-bit signed quantities, with the sign bit
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  197   * stored in 0x58.  Sign for v-red is bit 0, and up from there.
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  198   */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  199  #define	REG_CMATRIX_BASE 0x4f
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  200  #define   CMATRIX_LEN 6
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  201  #define REG_CMATRIX_SIGN 0x58
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  202  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  203  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  204  #define REG_BRIGHT	0x55	/* Brightness */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  205  #define REG_CONTRAS	0x56	/* Contrast control */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  206  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  207  #define REG_GFIX	0x69	/* Fix gain control */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  208  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  209  #define REG_RGB444	0x8c	/* RGB 444 control */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  210  #define   R444_ENABLE	  0x02	  /* Turn on RGB444, overrides 5x5 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  211  #define   R444_RGBX	  0x01	  /* Empty nibble at end */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  212  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  213  #define REG_HAECC1	0x9f	/* Hist AEC/AGC control 1 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  214  #define REG_HAECC2	0xa0	/* Hist AEC/AGC control 2 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  215  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  216  #define REG_BD50MAX	0xa5	/* 50hz banding step limit */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  217  #define REG_HAECC3	0xa6	/* Hist AEC/AGC control 3 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  218  #define REG_HAECC4	0xa7	/* Hist AEC/AGC control 4 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  219  #define REG_HAECC5	0xa8	/* Hist AEC/AGC control 5 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  220  #define REG_HAECC6	0xa9	/* Hist AEC/AGC control 6 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  221  #define REG_HAECC7	0xaa	/* Hist AEC/AGC control 7 */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  222  #define REG_BD60MAX	0xab	/* 60hz banding step limit */
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  223  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  224  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  225  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  226  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  227  /* Returns 0 if OK */
fe2b8f50 drivers/media/video/stk-sensor.c Adrian Bunk        2008-01-28  228  static int stk_sensor_outb(struct stk_camera *dev, u8 reg, u8 val)
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  229  {
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  230  	int i = 0;
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  231  	int tmpval = 0;
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  232  
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  233  	if (stk_camera_write_reg(dev, STK_IIC_TX_INDEX, reg))
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  234  		return 1;
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  235  	if (stk_camera_write_reg(dev, STK_IIC_TX_VALUE, val))
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  236  		return 1;
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  237  	if (stk_camera_write_reg(dev, STK_IIC_OP, STK_IIC_OP_TX))
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  238  		return 1;
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  239  	do {
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12 @240  		if (stk_camera_read_reg(dev, STK_IIC_STAT, &tmpval))
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  241  			return 1;
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  242  		i++;
ec16dae5 drivers/media/video/stk-sensor.c Jaime Velasco Juan 2008-01-12  243  	} while (tmpval == 0 && i < MAX_RETRIES);

:::::: The code at line 240 was first introduced by commit
:::::: ec16dae5453eafd1586f35c4ec1ef854e5a808e0 V4L/DVB (7019): V4L: add support for Syntek DC1125 webcams

:::::: TO: Jaime Velasco Juan <jsagarribay@gmail.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@infradead.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--pWyiEgJYm5f9v55/
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--pWyiEgJYm5f9v55/--
