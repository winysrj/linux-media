Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:20073 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaCYLw6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 07:52:58 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2Z00CDFQC8ZI20@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Mar 2014 07:52:56 -0400 (EDT)
Date: Tue, 25 Mar 2014 08:52:45 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: Re: [linuxtv-media:master 202/499] WARNING: CVS style keyword markers,
 these will _not_ be updated
Message-id: <20140325085245.02c2f4b2@samsung.com>
In-reply-to: <5330a979.sXMy7GbMSKAHyfG6%fengguang.wu@intel.com>
References: <5330a979.sXMy7GbMSKAHyfG6%fengguang.wu@intel.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fengguang,

Please don't do such checkpatch.pl tests like that. You'll be only
flooding the MLs with useless data.

For example, in the specific case of drx-j, the original driver was
crappy, and have hundreds or thousands of checkpatch errors/warnings.

However, It needed to be applied as-is, due to custody chain.
I latter wrote a series (~80 patches) fixing each of the issues pointed
by checkpatch (except for 80 cols warnings).

The code that got committed is still somewhat odd, but it has now on an 
acceptable coding style (well, someone would need to take some care
at the comments, as they don't follow the Kernel CodingStyle yet - but
this is a minor question, and even checkpatch.pl doesn't complain).

So, if you want to produce checkpatch.pl reports, you should really do
it at the end of the patch series, folding all the patches that touch
on a file together.

Regards,
Mauro

Em Tue, 25 Mar 2014 05:54:01 +0800
kbuild test robot <fengguang.wu@intel.com> escreveu:

> tree:   git://linuxtv.org/media_tree.git master
> head:   8432164ddf7bfe40748ac49995356ab4dfda43b7
> commit: 443f18d0d52d513810311601a9235cb22c72a85b [202/499] [media] drx-j: CodingStyle fixes
> 
> scripts/checkpatch.pl 0001-media-drx-j-CodingStyle-fixes.patch
> # many are suggestions rather than must-fix
> 
> WARNING: do not add new typedefs
> #92: drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h:62:
> +	typedef u16_t I2Caddr_t;
> 
> WARNING: do not add new typedefs
> #101: drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h:74:
> +	typedef u16_t I2CdevId_t;
> 
> WARNING: do not add new typedefs
> #130: drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h:100:
> +	typedef struct _I2CDeviceAddr_t I2CDeviceAddr_t;
> 
> WARNING: do not add new typedefs
> #137: drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h:106:
> +	typedef I2CDeviceAddr_t *pI2CDeviceAddr_t;
> 
> WARNING: do not add new typedefs
> #271: drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h:82:
> +	typedef u32_t TUNERMode_t;
> 
> WARNING: do not add new typedefs
> #272: drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h:83:
> +	typedef pu32_t pTUNERMode_t;
> 
> WARNING: do not add new typedefs
> #275: drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h:85:
> +	typedef char *TUNERSubMode_t;	/* description of submode */
> 
> WARNING: do not add new typedefs
> #276: drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h:86:
> +	typedef TUNERSubMode_t *pTUNERSubMode_t;
> 
> WARNING: do not add new typedefs
> #278: drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h:88:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #288: drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h:94:
> +	typedef struct {
> 
> WARNING: line over 80 characters
> #294: drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h:97:
> +		DRXFrequency_t minFreqRF;	/* Lowest  RF input frequency, in kHz */
> 
> WARNING: line over 80 characters
> #295: drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h:98:
> +		DRXFrequency_t maxFreqRF;	/* Highest RF input frequency, in kHz */
> 
> WARNING: line over 80 characters
> #304: drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h:101:
> +		pTUNERSubMode_t subModeDescriptions;	/* Pointer to description of sub-modes */
> 
> WARNING: line over 80 characters
> #309: drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h:104:
> +		/* The following fields will be either 0, NULL or FALSE and do not need
> 
> WARNING: line over 80 characters
> #313: drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h:108:
> +		DRXFrequency_t RFfrequency;	/* only valid if programmed       */
> 
> WARNING: line over 80 characters
> #314: drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h:109:
> +		DRXFrequency_t IFfrequency;	/* only valid if programmed       */
> 
> WARNING: line over 80 characters
> #317: drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h:111:
> +		void *myUserData;	/* pointer to associated demod instance */
> 
> WARNING: line over 80 characters
> #318: drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h:112:
> +		u16_t myCapabilities;	/* value for storing application flags  */
> 
> WARNING: do not add new typedefs
> #370: drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h:119:
> +	typedef struct TUNERInstance_s *pTUNERInstance_t;
> 
> WARNING: do not add new typedefs
> #399: drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h:148:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #409: drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h:158:
> +	typedef struct TUNERInstance_s {
> 
> WARNING: do not add new typedefs
> #489: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:59:
> +	typedef unsigned char u8_t;
> 
> WARNING: do not add new typedefs
> #495: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:64:
> +	typedef char s8_t;
> 
> WARNING: do not add new typedefs
> #501: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:69:
> +	typedef unsigned short u16_t;
> 
> WARNING: do not add new typedefs
> #507: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:74:
> +	typedef short s16_t;
> 
> WARNING: do not add new typedefs
> #513: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:79:
> +	typedef unsigned long u32_t;
> 
> WARNING: do not add new typedefs
> #519: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:84:
> +	typedef long s32_t;
> 
> WARNING: do not add new typedefs
> #528: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:89:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #540: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:97:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #550: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:106:
> +	typedef u8_t *pu8_t;
> 
> WARNING: do not add new typedefs
> #556: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:111:
> +	typedef s8_t *ps8_t;
> 
> WARNING: do not add new typedefs
> #562: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:116:
> +	typedef u16_t *pu16_t;
> 
> WARNING: do not add new typedefs
> #568: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:121:
> +	typedef s16_t *ps16_t;
> 
> WARNING: do not add new typedefs
> #574: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:126:
> +	typedef u32_t *pu32_t;
> 
> WARNING: do not add new typedefs
> #580: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:131:
> +	typedef s32_t *ps32_t;
> 
> WARNING: do not add new typedefs
> #586: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:136:
> +	typedef u64_t *pu64_t;
> 
> WARNING: do not add new typedefs
> #593: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:141:
> +	typedef s64_t *ps64_t;
> 
> WARNING: do not add new typedefs
> #600: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:147:
> +	typedef s32_t DRXFrequency_t;
> 
> WARNING: do not add new typedefs
> #607: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:153:
> +	typedef DRXFrequency_t *pDRXFrequency_t;
> 
> WARNING: do not add new typedefs
> #614: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:159:
> +	typedef u32_t DRXSymbolrate_t;
> 
> WARNING: do not add new typedefs
> #621: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:165:
> +	typedef DRXSymbolrate_t *pDRXSymbolrate_t;
> 
> WARNING: do not add new typedefs
> #630: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:186:
> +	typedef int Bool_t;
> 
> WARNING: do not add new typedefs
> #640: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:192:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #646: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:197:
> +	typedef Bool_t *pBool_t;
> 
> WARNING: do not add new typedefs
> #661: drivers/media/dvb-frontends/drx39xyj/bsp_types.h:203:
> +	typedef enum {
> 
> ERROR: "foo * bar" should be "foo *bar"
> #698: drivers/media/dvb-frontends/drx39xyj/drx39xxj.c:57:
> +static int drx39xxj_read_status(struct dvb_frontend *fe, fe_status_t * status)
> 
> ERROR: "foo * bar" should be "foo *bar"
> #732: drivers/media/dvb-frontends/drx39xyj/drx39xxj.c:104:
> +static int drx39xxj_read_ber(struct dvb_frontend *fe, u32 * ber)
> 
> ERROR: "foo * bar" should be "foo *bar"
> #747: drivers/media/dvb-frontends/drx39xyj/drx39xxj.c:123:
> +					 u16 * strength)
> 
> ERROR: "foo * bar" should be "foo *bar"
> #761: drivers/media/dvb-frontends/drx39xyj/drx39xxj.c:142:
> +static int drx39xxj_read_snr(struct dvb_frontend *fe, u16 * snr)
> 
> ERROR: "foo * bar" should be "foo *bar"
> #775: drivers/media/dvb-frontends/drx39xyj/drx39xxj.c:160:
> +static int drx39xxj_read_ucblocks(struct dvb_frontend *fe, u32 * ucblocks)
> 
> WARNING: Missing a blank line after declarations
> #882: drivers/media/dvb-frontends/drx39xyj/drx39xxj.c:259:
> +		fe_status_t status;
> +		drx39xxj_read_status(fe, &status);
> 
> WARNING: printk() should include KERN_ facility level
> #883: drivers/media/dvb-frontends/drx39xyj/drx39xxj.c:260:
> +		printk("i=%d status=%d\n", i, status);
> 
> ERROR: do not use C99 // comments
> #979: drivers/media/dvb-frontends/drx39xyj/drx39xxj.c:377:
> +	//      demod->myCommonAttr->verifyMicrocode = FALSE;
> 
> ERROR: return is not a function, parentheses are not required
> #1103: drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c:55:
> +	return (memcmp(s1, s2, (size_t) n));
> 
> ERROR: return is not a function, parentheses are not required
> #1110: drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c:60:
> +	return (memcpy(to, from, (size_t) n));
> 
> WARNING: printk() should include KERN_ facility level
> #1133: drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c:104:
> +		printk("i2c was zero, aborting\n");
> 
> ERROR: space required after that ',' (ctx:VxV)
> #1147: drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c:119:
> +		 .flags = 0,.buf = wData,.len = wCount},
>  		           ^
> 
> ERROR: space required after that ',' (ctx:VxV)
> #1147: drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c:119:
> +		 .flags = 0,.buf = wData,.len = wCount},
>  		                        ^
> 
> ERROR: space required after that ',' (ctx:VxV)
> #1149: drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c:121:
> +		 .flags = I2C_M_RD,.buf = rData,.len = rCount},
>  		                  ^
> 
> ERROR: space required after that ',' (ctx:VxV)
> #1149: drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c:121:
> +		 .flags = I2C_M_RD,.buf = rData,.len = rCount},
>  		                               ^
> 
> WARNING: CVS style keyword markers, these will _not_ be updated
> #1865: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:32:
> +* FILENAME: drx_dap_fasi.c,v 1.7 2009/12/28 14:36:21 carlo Exp $
> 
> WARNING: line over 80 characters
> #1891: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:58:
> +static DRXStatus_t DRXDAP_FASI_WriteBlock(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #1892: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:59:
> +					  DRXaddr_t addr,	/* address of register/memory   */
> 
> WARNING: line over 80 characters
> #1893: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:60:
> +					  u16_t datasize,	/* size of data                 */
> 
> WARNING: line over 80 characters
> #1894: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:61:
> +					  pu8_t data,	/* data to send                 */
> 
> WARNING: line over 80 characters
> #1895: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:62:
> +					  DRXflags_t flags);	/* special device flags         */
> 
> WARNING: line over 80 characters
> #1897: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:64:
> +static DRXStatus_t DRXDAP_FASI_ReadBlock(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #1898: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:65:
> +					 DRXaddr_t addr,	/* address of register/memory   */
> 
> WARNING: line over 80 characters
> #1899: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:66:
> +					 u16_t datasize,	/* size of data                 */
> 
> WARNING: line over 80 characters
> #1900: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:67:
> +					 pu8_t data,	/* data to send                 */
> 
> WARNING: line over 80 characters
> #1901: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:68:
> +					 DRXflags_t flags);	/* special device flags         */
> 
> WARNING: line over 80 characters
> #1903: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:70:
> +static DRXStatus_t DRXDAP_FASI_WriteReg8(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #1904: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:71:
> +					 DRXaddr_t addr,	/* address of register          */
> 
> WARNING: line over 80 characters
> #1905: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:72:
> +					 u8_t data,	/* data to write                */
> 
> WARNING: line over 80 characters
> #1906: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:73:
> +					 DRXflags_t flags);	/* special device flags         */
> 
> WARNING: line over 80 characters
> #1908: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:75:
> +static DRXStatus_t DRXDAP_FASI_ReadReg8(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #1909: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:76:
> +					DRXaddr_t addr,	/* address of register          */
> 
> WARNING: line over 80 characters
> #1910: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:77:
> +					pu8_t data,	/* buffer to receive data       */
> 
> WARNING: line over 80 characters
> #1911: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:78:
> +					DRXflags_t flags);	/* special device flags         */
> 
> WARNING: line over 80 characters
> #1913: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:80:
> +static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg8(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #1914: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:81:
> +						   DRXaddr_t waddr,	/* address of register          */
> 
> WARNING: line over 80 characters
> #1915: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:82:
> +						   DRXaddr_t raddr,	/* address to read back from    */
> 
> WARNING: line over 80 characters
> #1916: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:83:
> +						   u8_t datain,	/* data to send                 */
> 
> WARNING: line over 80 characters
> #1917: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:84:
> +						   pu8_t dataout);	/* data to receive back         */
> 
> WARNING: line over 80 characters
> #1919: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:86:
> +static DRXStatus_t DRXDAP_FASI_WriteReg16(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #1920: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:87:
> +					  DRXaddr_t addr,	/* address of register          */
> 
> WARNING: line over 80 characters
> #1921: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:88:
> +					  u16_t data,	/* data to write                */
> 
> WARNING: line over 80 characters
> #1922: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:89:
> +					  DRXflags_t flags);	/* special device flags         */
> 
> WARNING: line over 80 characters
> #1924: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:91:
> +static DRXStatus_t DRXDAP_FASI_ReadReg16(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #1925: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:92:
> +					 DRXaddr_t addr,	/* address of register          */
> 
> WARNING: line over 80 characters
> #1926: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:93:
> +					 pu16_t data,	/* buffer to receive data       */
> 
> WARNING: line over 80 characters
> #1927: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:94:
> +					 DRXflags_t flags);	/* special device flags         */
> 
> WARNING: line over 80 characters
> #1929: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:96:
> +static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg16(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #1930: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:97:
> +						    DRXaddr_t waddr,	/* address of register          */
> 
> WARNING: line over 80 characters
> #1931: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:98:
> +						    DRXaddr_t raddr,	/* address to read back from    */
> 
> WARNING: line over 80 characters
> #1932: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:99:
> +						    u16_t datain,	/* data to send                 */
> 
> WARNING: line over 80 characters
> #1933: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:100:
> +						    pu16_t dataout);	/* data to receive back         */
> 
> WARNING: line over 80 characters
> #1935: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:102:
> +static DRXStatus_t DRXDAP_FASI_WriteReg32(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #1936: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:103:
> +					  DRXaddr_t addr,	/* address of register          */
> 
> WARNING: line over 80 characters
> #1937: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:104:
> +					  u32_t data,	/* data to write                */
> 
> WARNING: line over 80 characters
> #1938: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:105:
> +					  DRXflags_t flags);	/* special device flags         */
> 
> WARNING: line over 80 characters
> #1940: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:107:
> +static DRXStatus_t DRXDAP_FASI_ReadReg32(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #1941: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:108:
> +					 DRXaddr_t addr,	/* address of register          */
> 
> WARNING: line over 80 characters
> #1942: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:109:
> +					 pu32_t data,	/* buffer to receive data       */
> 
> WARNING: line over 80 characters
> #1943: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:110:
> +					 DRXflags_t flags);	/* special device flags         */
> 
> WARNING: line over 80 characters
> #1945: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:112:
> +static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg32(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #1946: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:113:
> +						    DRXaddr_t waddr,	/* address of register          */
> 
> WARNING: line over 80 characters
> #1947: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:114:
> +						    DRXaddr_t raddr,	/* address to read back from    */
> 
> WARNING: line over 80 characters
> #1948: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:115:
> +						    u32_t datain,	/* data to send                 */
> 
> WARNING: line over 80 characters
> #1949: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:116:
> +						    pu32_t dataout);	/* data to receive back         */
> 
> WARNING: line over 80 characters
> #1985: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:152:
> +static DRXStatus_t DRXDAP_FASI_WriteReg8(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #1986: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:153:
> +					 DRXaddr_t addr,	/* address of register          */
> 
> WARNING: line over 80 characters
> #1987: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:154:
> +					 u8_t data,	/* data to write                */
> 
> WARNING: line over 80 characters
> #1993: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:160:
> +static DRXStatus_t DRXDAP_FASI_ReadReg8(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #1994: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:161:
> +					DRXaddr_t addr,	/* address of register          */
> 
> WARNING: line over 80 characters
> #1995: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:162:
> +					pu8_t data,	/* buffer to receive data       */
> 
> WARNING: line over 80 characters
> #2001: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:168:
> +static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg8(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #2002: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:169:
> +						   DRXaddr_t waddr,	/* address of register          */
> 
> WARNING: line over 80 characters
> #2003: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:170:
> +						   DRXaddr_t raddr,	/* address to read back from    */
> 
> WARNING: line over 80 characters
> #2004: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:171:
> +						   u8_t datain,	/* data to send                 */
> 
> WARNING: line over 80 characters
> #2010: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:177:
> +static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg32(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #2011: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:178:
> +						    DRXaddr_t waddr,	/* address of register          */
> 
> WARNING: line over 80 characters
> #2012: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:179:
> +						    DRXaddr_t raddr,	/* address to read back from    */
> 
> WARNING: line over 80 characters
> #2013: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:180:
> +						    u32_t datain,	/* data to send                 */
> 
> WARNING: line over 80 characters
> #2056: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:223:
> +	/* Check parameters ******************************************************* */
> 
> WARNING: braces {} are not necessary for single statement blocks
> #2057: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:224:
> +	if (devAddr == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: line over 80 characters
> #2078: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:245:
> +	/* Read block from I2C **************************************************** */
> 
> WARNING: Missing a blank line after declarations
> #2081: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:248:
> +		u16_t todo = (datasize < DRXDAP_MAX_RCHUNKSIZE ?
> +			      datasize : DRXDAP_MAX_RCHUNKSIZE);
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #2088: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:255:
> +#if ( ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 ) && \
>                                      ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #2088: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:255:
> +#if ( ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 ) && \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #2088: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:255:
> +#if ( ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 ) && \
> 
> WARNING: please, no spaces at the start of a line
> #2089: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:256:
> +      ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 ) )$
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #2089: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:256:
> +      ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 ) )
>                                       ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #2089: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:256:
> +      ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #2089: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:256:
> +      ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 ) )
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #2093: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:260:
> +#if ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 )
>                                    ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #2093: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:260:
> +#if ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #2093: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:260:
> +#if ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 )
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #2099: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:266:
> +#if ( ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 ) && \
>                                      ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #2099: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:266:
> +#if ( ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 ) && \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #2099: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:266:
> +#if ( ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 ) && \
> 
> WARNING: please, no spaces at the start of a line
> #2100: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:267:
> +      ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 ) )$
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #2100: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:267:
> +      ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 ) )
>                                       ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #2100: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:267:
> +      ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #2100: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:267:
> +      ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 ) )
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #2103: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:270:
> +#if ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 )
>                                     ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #2103: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:270:
> +#if ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #2103: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:270:
> +#if ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 )
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #2109: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:276:
> +#if ( ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 ) && \
>                                      ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #2109: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:276:
> +#if ( ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 ) && \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #2109: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:276:
> +#if ( ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 ) && \
> 
> WARNING: please, no spaces at the start of a line
> #2110: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:277:
> +      ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 ) )$
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #2110: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:277:
> +      ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 ) )
>                                       ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #2110: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:277:
> +      ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #2110: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:277:
> +      ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 ) )
> 
> WARNING: braces {} are not necessary for single statement blocks
> #2120: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:287:
> +		if (rc == DRX_STS_OK) {
> +			rc = DRXBSP_I2C_WriteRead(0, 0, 0, devAddr, todo, data);
> +		}
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #2168: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:335:
> +#if ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 )
>                                    ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #2168: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:335:
> +#if ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #2168: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:335:
> +#if ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 )
> 
> WARNING: braces {} are not necessary for single statement blocks
> #2169: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:336:
> +	if (rdata == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #2174: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:341:
> +	if (rc == DRX_STS_OK) {
> +		rc = DRXDAP_FASI_ReadReg16(devAddr, raddr, rdata, 0);
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #2207: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:374:
> +	if (!data) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #2240: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:407:
> +	if (!data) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: line over 80 characters
> #2283: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:450:
> +	/* Check parameters ******************************************************* */
> 
> WARNING: braces {} are not necessary for single statement blocks
> #2284: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:451:
> +	if (devAddr == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: line over 80 characters
> #2305: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:472:
> +	/* Write block to I2C ***************************************************** */
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #2314: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:481:
> +#if ( ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 ) && \
>                                        ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #2314: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:481:
> +#if ( ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 ) && \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #2314: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:481:
> +#if ( ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 ) && \
> 
> WARNING: please, no spaces at the start of a line
> #2315: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:482:
> +      ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 ) )$
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #2315: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:482:
> +      ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 ) )
>                                         ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #2315: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:482:
> +      ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #2315: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:482:
> +      ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 ) )
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #2319: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:486:
> +#if ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 )
>                                      ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #2319: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:486:
> +#if ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #2319: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:486:
> +#if ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 )
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #2325: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:492:
> +#if ( ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 ) && \
>                                        ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #2325: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:492:
> +#if ( ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 ) && \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #2325: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:492:
> +#if ( ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 ) && \
> 
> WARNING: please, no spaces at the start of a line
> #2326: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:493:
> +      ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 ) )$
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #2326: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:493:
> +      ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 ) )
>                                         ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #2326: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:493:
> +      ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #2326: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:493:
> +      ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 ) )
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #2329: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:496:
> +#if ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 )
>                                       ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #2329: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:496:
> +#if ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #2329: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:496:
> +#if ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 )
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #2335: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:502:
> +#if ( ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 ) && \
>                                        ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #2335: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:502:
> +#if ( ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 ) && \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #2335: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:502:
> +#if ( ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 ) && \
> 
> WARNING: please, no spaces at the start of a line
> #2336: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:503:
> +      ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 ) )$
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #2336: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:503:
> +      ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 ) )
>                                         ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #2336: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:503:
> +      ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #2336: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:503:
> +      ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 ) )
> 
> WARNING: line over 80 characters
> #2341: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:508:
> +		   In single master mode blockSize can be 0. In such a case this I2C
> 
> WARNING: line over 80 characters
> #2343: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:510:
> +		   4 bytes chip address} (2) write data {i2c addr, 4 bytes data }
> 
> WARNING: line over 80 characters
> #2345: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:512:
> +		   Addres must be rewriten because HI is reset after data transport and
> 
> WARNING: line over 80 characters
> #2366: drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c:533:
> +				/* at the end, return the first error encountered */
> 
> WARNING: CVS style keyword markers, these will _not_ be updated
> #4175: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:32:
> +* \file $Id:24:56 lfeng Exp $
> 
> ERROR: space prohibited after that open parenthesis '('
> #4246: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:103:
> +#define DRX_ISPOWERDOWNMODE( mode ) (  ( mode == DRX_POWER_MODE_9  ) || \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #4246: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:103:
> +#define DRX_ISPOWERDOWNMODE( mode ) (  ( mode == DRX_POWER_MODE_9  ) || \
> 
> ERROR: space prohibited after that open parenthesis '('
> #4247: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:104:
> +				       ( mode == DRX_POWER_MODE_10 ) || \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #4247: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:104:
> +				       ( mode == DRX_POWER_MODE_10 ) || \
> 
> ERROR: space prohibited after that open parenthesis '('
> #4248: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:105:
> +				       ( mode == DRX_POWER_MODE_11 ) || \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #4248: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:105:
> +				       ( mode == DRX_POWER_MODE_11 ) || \
> 
> ERROR: space prohibited after that open parenthesis '('
> #4249: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:106:
> +				       ( mode == DRX_POWER_MODE_12 ) || \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #4249: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:106:
> +				       ( mode == DRX_POWER_MODE_12 ) || \
> 
> ERROR: space prohibited after that open parenthesis '('
> #4250: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:107:
> +				       ( mode == DRX_POWER_MODE_13 ) || \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #4250: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:107:
> +				       ( mode == DRX_POWER_MODE_13 ) || \
> 
> ERROR: space prohibited after that open parenthesis '('
> #4251: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:108:
> +				       ( mode == DRX_POWER_MODE_14 ) || \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #4251: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:108:
> +				       ( mode == DRX_POWER_MODE_14 ) || \
> 
> ERROR: space prohibited after that open parenthesis '('
> #4252: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:109:
> +				       ( mode == DRX_POWER_MODE_15 ) || \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #4252: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:109:
> +				       ( mode == DRX_POWER_MODE_15 ) || \
> 
> ERROR: space prohibited after that open parenthesis '('
> #4253: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:110:
> +				       ( mode == DRX_POWER_MODE_16 ) || \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #4253: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:110:
> +				       ( mode == DRX_POWER_MODE_16 ) || \
> 
> ERROR: space prohibited after that open parenthesis '('
> #4254: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:111:
> +				       ( mode == DRX_POWER_DOWN    ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #4254: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:111:
> +				       ( mode == DRX_POWER_DOWN    ) )
> 
> WARNING: do not add new typedefs
> #4264: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:121:
> +typedef struct {
> 
> WARNING: braces {} are not necessary for single statement blocks
> #4333: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:190:
> +	if (scanContext == NULL) {
> +		scanContext = (void *)demod;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #4387: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:244:
> +		else if (lockState == DRX_NEVER_LOCK) {
> +			doneWaiting = TRUE;
> +		} /* if ( lockState == DRX_NEVER_LOCK ) .. */
> 
> WARNING: braces {} are not necessary for single statement blocks
> #4394: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:251:
> +			if (DRXBSP_HST_Sleep(10) != DRX_STS_OK) {
> +				return DRX_STS_ERROR;
> +			}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #4519: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:376:
> +	if (status != DRX_STS_OK) {
> +		return (status);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #4520: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:377:
> +		return (status);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #4524: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:381:
> +	if (status != DRX_STS_OK) {
> +		return status;
> +	}
> 
> WARNING: line over 80 characters
> #4606: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:463:
> +			/* First center frequency is higher than last center frequency */
> 
> WARNING: line over 80 characters
> #4614: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:471:
> +			/* Difference between last and first center frequency is not
> 
> WARNING: line over 80 characters
> #4657: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:514:
> +			/* Determine first frequency (within tuner range) to scan */
> 
> WARNING: line over 80 characters
> #4768: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:625:
> +		/* CtrlScanInit() was not called succesfully before CtrlScanNext() */
> 
> WARNING: line over 80 characters
> #4822: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:679:
> +				/* a channel was found, so skip some frequency steps */
> 
> ERROR: return is not a function, parentheses are not required
> #4835: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:692:
> +				return (nextStatus);
> 
> ERROR: return is not a function, parentheses are not required
> #4849: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:706:
> +		return (DRX_STS_READY);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #4885: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:742:
> +	if (demod->myTuner == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #4892: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:749:
> +	if (DRX_Ctrl(demod, DRX_CTRL_GET_STANDARD, &standard) != DRX_STS_OK) {
> +		return DRX_STS_ERROR;
> +	}
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #4921: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:778:
> +	if (tunerSlowMode) {
> [...]
> +	} else {
> [...]
> 
> WARNING: braces {} are not necessary for single statement blocks
> #4933: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:790:
> +		if (statusBridge != DRX_STS_OK) {
> +			return statusBridge;
> +		}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #4948: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:805:
> +		if (statusBridge != DRX_STS_OK) {
> +			return statusBridge;
> +		}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #4954: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:811:
> +	if (status != DRX_STS_OK) {
> +		return status;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #4963: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:820:
> +	if (status != DRX_STS_OK) {
> +		return status;
> +	}
> 
> WARNING: line over 80 characters
> #4967: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:824:
> +	/* update common attributes with information available from this function;
> 
> WARNING: line over 80 characters
> #5011: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:868:
> +			   depending on device ID, some HW blocks might not be available */
> 
> WARNING: braces {} are not necessary for single statement blocks
> #5097: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:954:
> +			if (carry != 0) {
> +				CRCWord ^= 0x80050000UL;
> +			}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #5142: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:999:
> +	if ((mcInfo == NULL) || (mcInfo->mcData == NULL)) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: Missing a blank line after declarations
> #5183: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1040:
> +				u16_t auxtype = UCodeRead16(auxblk);
> +				if (DRX_ISMCVERTYPE(auxtype)) {
> 
> WARNING: braces {} are not necessary for single statement blocks
> #5206: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1063:
> +		if (rc != DRX_STS_OK && rc != DRX_STS_FUNC_NOT_AVAILABLE) {
> +			return rc;
> +		}
> 
> ERROR: return is not a function, parentheses are not required
> #5257: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1114:
> +						return (DRX_STS_ERROR);
> 
> WARNING: Too many leading tabs - consider code refactoring
> #5278: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1135:
> +						if (bytesLeftToCompare >
> 
> WARNING: line over 80 characters
> #5283: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1140:
> +							     DRX_UCODE_MAX_BUF_SIZE);
> 
> WARNING: Too many leading tabs - consider code refactoring
> #5284: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1141:
> +						} else {
> 
> WARNING: Too many leading tabs - consider code refactoring
> #5289: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1146:
> +						if (demod->myAccessFunct->
> 
> WARNING: line over 80 characters
> #5293: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1150:
> +								  bytesToCompare,
> 
> ERROR: return is not a function, parentheses are not required
> #5298: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1155:
> +							return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #5303: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1160:
> +								      mcDataBuffer,
> 
> WARNING: line over 80 characters
> #5304: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1161:
> +								      bytesToCompare);
> 
> WARNING: Too many leading tabs - consider code refactoring
> #5306: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1163:
> +						if (result != 0) {
> 
> WARNING: braces {} are not necessary for single statement blocks
> #5306: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1163:
> +						if (result != 0) {
> +							return DRX_STS_ERROR;
> +						}
> 
> WARNING: line over 80 characters
> #5317: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1174:
> +					}	/* while( bytesToCompare > DRX_UCODE_MAX_BUF_SIZE ) */
> 
> ERROR: "foo * bar" should be "foo *bar"
> #5349: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1206:
> +CtrlVersion(pDRXDemodInstance_t demod, pDRXVersionList_t * versionList)
> 
> WARNING: static char array declaration should probably be static const char
> #5351: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1208:
> +	static char drxDriverCoreModuleName[] = "Core driver";
> 
> WARNING: braces {} are not necessary for single statement blocks
> #5362: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1219:
> +	if (versionList == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: Missing a blank line after declarations
> #5388: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1245:
> +		pDRXVersionList_t currentListElement = demodVersionList;
> +		while (currentListElement->next != NULL) {
> 
> WARNING: braces {} are not necessary for single statement blocks
> #5388: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1245:
> +		while (currentListElement->next != NULL) {
> +			currentListElement = currentListElement->next;
> +		}
> 
> ERROR: return is not a function, parentheses are not required
> #5462: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1319:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #5467: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1324:
> +	if (status == DRX_STS_OK) {
> +		demod->myCommonAttr->isOpened = TRUE;
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #5539: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1396:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #5545: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1402:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #5645: drivers/media/dvb-frontends/drx39xyj/drx_driver.c:1502:
> +		return (status);
> 
> WARNING: do not add new typedefs
> #5678: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:297:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #5728: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:329:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #5750: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:344:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #5770: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:358:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #5798: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:371:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #5828: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:393:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #5848: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:408:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #5868: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:419:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #5892: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:435:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #5914: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:450:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #5938: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:464:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #5981: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:481:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #6020: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:514:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #6041: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:526:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #6066: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:544:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #6086: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:557:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #6107: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:570:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #6120: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:582:
> +	typedef u32_t DRXCtrlIndex_t, *pDRXCtrlIndex_t;
> 
> WARNING: line over 80 characters
> #6146: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:639:
> +#define DRX_CTRL_MAX             ( DRX_CTRL_BASE + 44)	/* never to be used    */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6146: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:639:
> +#define DRX_CTRL_MAX             ( DRX_CTRL_BASE + 44)	/* never to be used    */
> 
> WARNING: do not add new typedefs
> #6158: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:646:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #6185: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:659:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #6250: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:689:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #6303: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:734:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #6336: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:761:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #6352: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:784:
> +	typedef u32_t DRXCfgType_t, *pDRXCfgType_t;
> 
> WARNING: line over 80 characters
> #6377: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:790:
> +#define DRX_CFG_MPEG_OUTPUT         ( DRX_CFG_BASE +  0)	/* MPEG TS output    */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6377: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:790:
> +#define DRX_CFG_MPEG_OUTPUT         ( DRX_CFG_BASE +  0)	/* MPEG TS output    */
> 
> WARNING: line over 80 characters
> #6378: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:791:
> +#define DRX_CFG_PKTERR              ( DRX_CFG_BASE +  1)	/* Packet Error      */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6378: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:791:
> +#define DRX_CFG_PKTERR              ( DRX_CFG_BASE +  1)	/* Packet Error      */
> 
> WARNING: line over 80 characters
> #6379: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:792:
> +#define DRX_CFG_SYMCLK_OFFS         ( DRX_CFG_BASE +  2)	/* Symbol Clk Offset */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6379: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:792:
> +#define DRX_CFG_SYMCLK_OFFS         ( DRX_CFG_BASE +  2)	/* Symbol Clk Offset */
> 
> WARNING: line over 80 characters
> #6380: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:793:
> +#define DRX_CFG_SMA                 ( DRX_CFG_BASE +  3)	/* Smart Antenna     */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6380: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:793:
> +#define DRX_CFG_SMA                 ( DRX_CFG_BASE +  3)	/* Smart Antenna     */
> 
> WARNING: line over 80 characters
> #6381: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:794:
> +#define DRX_CFG_PINSAFE             ( DRX_CFG_BASE +  4)	/* Pin safe mode     */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6381: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:794:
> +#define DRX_CFG_PINSAFE             ( DRX_CFG_BASE +  4)	/* Pin safe mode     */
> 
> WARNING: line over 80 characters
> #6382: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:795:
> +#define DRX_CFG_SUBSTANDARD         ( DRX_CFG_BASE +  5)	/* substandard       */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6382: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:795:
> +#define DRX_CFG_SUBSTANDARD         ( DRX_CFG_BASE +  5)	/* substandard       */
> 
> WARNING: line over 80 characters
> #6383: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:796:
> +#define DRX_CFG_AUD_VOLUME          ( DRX_CFG_BASE +  6)	/* volume            */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6383: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:796:
> +#define DRX_CFG_AUD_VOLUME          ( DRX_CFG_BASE +  6)	/* volume            */
> 
> WARNING: line over 80 characters
> #6384: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:797:
> +#define DRX_CFG_AUD_RDS             ( DRX_CFG_BASE +  7)	/* rds               */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6384: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:797:
> +#define DRX_CFG_AUD_RDS             ( DRX_CFG_BASE +  7)	/* rds               */
> 
> WARNING: line over 80 characters
> #6385: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:798:
> +#define DRX_CFG_AUD_AUTOSOUND       ( DRX_CFG_BASE +  8)	/* ASS & ASC         */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6385: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:798:
> +#define DRX_CFG_AUD_AUTOSOUND       ( DRX_CFG_BASE +  8)	/* ASS & ASC         */
> 
> WARNING: line over 80 characters
> #6386: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:799:
> +#define DRX_CFG_AUD_ASS_THRES       ( DRX_CFG_BASE +  9)	/* ASS Thresholds    */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6386: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:799:
> +#define DRX_CFG_AUD_ASS_THRES       ( DRX_CFG_BASE +  9)	/* ASS Thresholds    */
> 
> WARNING: line over 80 characters
> #6387: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:800:
> +#define DRX_CFG_AUD_DEVIATION       ( DRX_CFG_BASE + 10)	/* Deviation         */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6387: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:800:
> +#define DRX_CFG_AUD_DEVIATION       ( DRX_CFG_BASE + 10)	/* Deviation         */
> 
> WARNING: line over 80 characters
> #6388: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:801:
> +#define DRX_CFG_AUD_PRESCALE        ( DRX_CFG_BASE + 11)	/* Prescale          */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6388: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:801:
> +#define DRX_CFG_AUD_PRESCALE        ( DRX_CFG_BASE + 11)	/* Prescale          */
> 
> WARNING: line over 80 characters
> #6389: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:802:
> +#define DRX_CFG_AUD_MIXER           ( DRX_CFG_BASE + 12)	/* Mixer             */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6389: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:802:
> +#define DRX_CFG_AUD_MIXER           ( DRX_CFG_BASE + 12)	/* Mixer             */
> 
> WARNING: line over 80 characters
> #6390: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:803:
> +#define DRX_CFG_AUD_AVSYNC          ( DRX_CFG_BASE + 13)	/* AVSync            */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6390: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:803:
> +#define DRX_CFG_AUD_AVSYNC          ( DRX_CFG_BASE + 13)	/* AVSync            */
> 
> WARNING: line over 80 characters
> #6391: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:804:
> +#define DRX_CFG_AUD_CARRIER         ( DRX_CFG_BASE + 14)	/* Audio carriers    */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6391: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:804:
> +#define DRX_CFG_AUD_CARRIER         ( DRX_CFG_BASE + 14)	/* Audio carriers    */
> 
> WARNING: line over 80 characters
> #6392: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:805:
> +#define DRX_CFG_I2S_OUTPUT          ( DRX_CFG_BASE + 15)	/* I2S output        */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6392: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:805:
> +#define DRX_CFG_I2S_OUTPUT          ( DRX_CFG_BASE + 15)	/* I2S output        */
> 
> WARNING: line over 80 characters
> #6393: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:806:
> +#define DRX_CFG_ATV_STANDARD        ( DRX_CFG_BASE + 16)	/* ATV standard      */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6393: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:806:
> +#define DRX_CFG_ATV_STANDARD        ( DRX_CFG_BASE + 16)	/* ATV standard      */
> 
> WARNING: line over 80 characters
> #6394: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:807:
> +#define DRX_CFG_SQI_SPEED           ( DRX_CFG_BASE + 17)	/* SQI speed         */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6394: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:807:
> +#define DRX_CFG_SQI_SPEED           ( DRX_CFG_BASE + 17)	/* SQI speed         */
> 
> WARNING: line over 80 characters
> #6395: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:808:
> +#define DRX_CTRL_CFG_MAX            ( DRX_CFG_BASE + 18)	/* never to be used  */
> 
> ERROR: space prohibited after that open parenthesis '('
> #6395: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:808:
> +#define DRX_CTRL_CFG_MAX            ( DRX_CFG_BASE + 18)	/* never to be used  */
> 
> WARNING: do not add new typedefs
> #6407: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:823:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #6426: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:849:
> +	typedef struct {
> 
> WARNING: line over 80 characters
> #6427: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:850:
> +		u16_t auxType;	/* type of aux data - 0x8000 for version record     */
> 
> WARNING: line over 80 characters
> #6428: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:851:
> +		u32_t mcDevType;	/* device type, based on JTAG ID                    */
> 
> WARNING: line over 80 characters
> #6429: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:852:
> +		u32_t mcVersion;	/* version of microcode                             */
> 
> WARNING: line over 80 characters
> #6430: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:853:
> +		u32_t mcBaseVersion;	/* in case of patch: the original microcode version */
> 
> WARNING: do not add new typedefs
> #6447: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:864:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #6482: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:885:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #6534: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:920:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #6553: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:939:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #6571: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:954:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #6590: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:969:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #6620: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:994:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #6638: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1006:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #6658: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1022:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #6674: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1035:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #6697: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1051:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #6734: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1075:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #6777: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1098:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #6835: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1146:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #6861: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1164:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #6882: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1181:
> +	typedef struct DRXVersionList_s {
> 
> WARNING: do not add new typedefs
> #6898: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1194:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #6915: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1208:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #6932: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1222:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #6955: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1237:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #6972: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1252:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #6990: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1266:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7005: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1280:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #7043: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1305:
> +	typedef enum DRXCfgSMAIO_t {
> 
> WARNING: do not add new typedefs
> #7057: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1314:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #7078: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1330:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #7115: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1350:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7151: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1381:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7172: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1393:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #7193: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1410:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #7210: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1420:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7227: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1432:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7242: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1442:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7263: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1453:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #7285: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1471:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7298: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1480:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7311: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1489:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7328: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1500:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7346: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1509:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #7367: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1525:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7382: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1536:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7397: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1546:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7411: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1555:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7426: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1565:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #7442: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1575:
> +	typedef struct {
> 
> WARNING: line over 80 characters
> #7443: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1576:
> +		u16_t thres;	/* carrier detetcion threshold for primary carrier (A) */
> 
> WARNING: line over 80 characters
> #7444: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1577:
> +		DRXNoCarrierOption_t opt;	/* Mute or noise at no carrier detection (A) */
> 
> WARNING: do not add new typedefs
> #7457: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1586:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #7473: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1595:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7491: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1606:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7513: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1621:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7530: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1633:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #7548: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1645:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7566: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1659:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #7581: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1668:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #7595: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1678:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7625: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1687:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #7654: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1711:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #7666: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1723:
> +	typedef u32_t DRXaddr_t, *pDRXaddr_t;
> 
> WARNING: do not add new typedefs
> #7670: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1726:
> +	typedef u32_t DRXflags_t, *pDRXflags_t;
> 
> WARNING: line over 80 characters
> #7679: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1729:
> +	typedef DRXStatus_t(*DRXWriteBlockFunc_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #7680: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1730:
> +						   DRXaddr_t addr,	/* address of register/memory   */
> 
> WARNING: line over 80 characters
> #7681: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1731:
> +						   u16_t datasize,	/* size of data in bytes        */
> 
> WARNING: line over 80 characters
> #7682: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1732:
> +						   pu8_t data,	/* data to send                 */
> 
> WARNING: line over 80 characters
> #7692: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1736:
> +	typedef DRXStatus_t(*DRXReadBlockFunc_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #7693: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1737:
> +						  DRXaddr_t addr,	/* address of register/memory   */
> 
> WARNING: line over 80 characters
> #7694: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1738:
> +						  u16_t datasize,	/* size of data in bytes        */
> 
> WARNING: line over 80 characters
> #7695: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1739:
> +						  pu8_t data,	/* receive buffer               */
> 
> WARNING: line over 80 characters
> #7704: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1743:
> +	typedef DRXStatus_t(*DRXWriteReg8Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #7705: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1744:
> +						  DRXaddr_t addr,	/* address of register/memory   */
> 
> WARNING: line over 80 characters
> #7706: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1745:
> +						  u8_t data,	/* data to send                 */
> 
> WARNING: line over 80 characters
> #7715: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1749:
> +	typedef DRXStatus_t(*DRXReadReg8Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #7716: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1750:
> +						 DRXaddr_t addr,	/* address of register/memory   */
> 
> WARNING: line over 80 characters
> #7717: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1751:
> +						 pu8_t data,	/* receive buffer               */
> 
> WARNING: line over 80 characters
> #7727: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1755:
> +	typedef DRXStatus_t(*DRXReadModifyWriteReg8Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device       */
> 
> WARNING: line over 80 characters
> #7728: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1756:
> +							    DRXaddr_t waddr,	/* write address of register   */
> 
> WARNING: line over 80 characters
> #7729: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1757:
> +							    DRXaddr_t raddr,	/* read  address of register   */
> 
> WARNING: line over 80 characters
> #7730: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1758:
> +							    u8_t wdata,	/* data to write               */
> 
> WARNING: line over 80 characters
> #7731: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1759:
> +							    pu8_t rdata);	/* data to read                */
> 
> WARNING: line over 80 characters
> #7739: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1762:
> +	typedef DRXStatus_t(*DRXWriteReg16Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #7740: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1763:
> +						   DRXaddr_t addr,	/* address of register/memory   */
> 
> WARNING: line over 80 characters
> #7741: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1764:
> +						   u16_t data,	/* data to send                 */
> 
> WARNING: line over 80 characters
> #7750: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1768:
> +	typedef DRXStatus_t(*DRXReadReg16Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #7751: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1769:
> +						  DRXaddr_t addr,	/* address of register/memory   */
> 
> WARNING: line over 80 characters
> #7752: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1770:
> +						  pu16_t data,	/* receive buffer               */
> 
> WARNING: line over 80 characters
> #7762: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1774:
> +	typedef DRXStatus_t(*DRXReadModifyWriteReg16Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device       */
> 
> WARNING: line over 80 characters
> #7763: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1775:
> +							     DRXaddr_t waddr,	/* write address of register   */
> 
> WARNING: line over 80 characters
> #7764: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1776:
> +							     DRXaddr_t raddr,	/* read  address of register   */
> 
> WARNING: line over 80 characters
> #7765: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1777:
> +							     u16_t wdata,	/* data to write               */
> 
> WARNING: line over 80 characters
> #7766: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1778:
> +							     pu16_t rdata);	/* data to read                */
> 
> WARNING: line over 80 characters
> #7774: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1781:
> +	typedef DRXStatus_t(*DRXWriteReg32Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #7775: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1782:
> +						   DRXaddr_t addr,	/* address of register/memory   */
> 
> WARNING: line over 80 characters
> #7776: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1783:
> +						   u32_t data,	/* data to send                 */
> 
> WARNING: line over 80 characters
> #7785: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1787:
> +	typedef DRXStatus_t(*DRXReadReg32Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
> 
> WARNING: line over 80 characters
> #7786: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1788:
> +						  DRXaddr_t addr,	/* address of register/memory   */
> 
> WARNING: line over 80 characters
> #7787: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1789:
> +						  pu32_t data,	/* receive buffer               */
> 
> WARNING: line over 80 characters
> #7797: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1793:
> +	typedef DRXStatus_t(*DRXReadModifyWriteReg32Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device       */
> 
> WARNING: line over 80 characters
> #7798: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1794:
> +							     DRXaddr_t waddr,	/* write address of register   */
> 
> WARNING: line over 80 characters
> #7799: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1795:
> +							     DRXaddr_t raddr,	/* read  address of register   */
> 
> WARNING: line over 80 characters
> #7800: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1796:
> +							     u32_t wdata,	/* data to write               */
> 
> WARNING: line over 80 characters
> #7801: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1797:
> +							     pu32_t rdata);	/* data to read                */
> 
> WARNING: do not add new typedefs
> #7821: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1803:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #7838: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1819:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #7912: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1836:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #7997: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1920:
> +	typedef struct DRXDemodInstance_s *pDRXDemodInstance_t;
> 
> WARNING: do not add new typedefs
> #8020: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1932:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #8043: drivers/media/dvb-frontends/drx39xyj/drx_driver.h:1943:
> +	typedef struct DRXDemodInstance_s {
> 
> WARNING: CVS style keyword markers, these will _not_ be updated
> #24865: drivers/media/dvb-frontends/drx39xyj/drxj.c:32:
> +* \file $Id:21:10 dingtao Exp $
> 
> WARNING: line over 80 characters
> #24957: drivers/media/dvb-frontends/drx39xyj/drxj.c:124:
> +#define     ATV_TOP_EQU1_EQU_C1_L                                           0x1F6
> 
> WARNING: line over 80 characters
> #24958: drivers/media/dvb-frontends/drx39xyj/drxj.c:125:
> +#define     ATV_TOP_EQU1_EQU_C1_LP                                          0x1F6
> 
> WARNING: line over 80 characters
> #24959: drivers/media/dvb-frontends/drx39xyj/drxj.c:126:
> +#define     ATV_TOP_EQU1_EQU_C1_BG                                          0x197
> 
> WARNING: line over 80 characters
> #24960: drivers/media/dvb-frontends/drx39xyj/drxj.c:127:
> +#define     ATV_TOP_EQU1_EQU_C1_DK                                          0x198
> 
> WARNING: line over 80 characters
> #24961: drivers/media/dvb-frontends/drx39xyj/drxj.c:128:
> +#define     ATV_TOP_EQU1_EQU_C1_I                                           0x1F6
> 
> WARNING: line over 80 characters
> #24969: drivers/media/dvb-frontends/drx39xyj/drxj.c:136:
> +#define     ATV_TOP_EQU3_EQU_C3_L                                           0x192
> 
> WARNING: line over 80 characters
> #24970: drivers/media/dvb-frontends/drx39xyj/drxj.c:137:
> +#define     ATV_TOP_EQU3_EQU_C3_LP                                          0x192
> 
> WARNING: line over 80 characters
> #24971: drivers/media/dvb-frontends/drx39xyj/drxj.c:138:
> +#define     ATV_TOP_EQU3_EQU_C3_BG                                          0x12E
> 
> WARNING: line over 80 characters
> #24972: drivers/media/dvb-frontends/drx39xyj/drxj.c:139:
> +#define     ATV_TOP_EQU3_EQU_C3_DK                                          0x18E
> 
> WARNING: line over 80 characters
> #24973: drivers/media/dvb-frontends/drx39xyj/drxj.c:140:
> +#define     ATV_TOP_EQU3_EQU_C3_I                                           0x192
> 
> WARNING: line over 80 characters
> #24988: drivers/media/dvb-frontends/drx39xyj/drxj.c:155:
> +#define   ATV_TOP_VID_AMP_MN                                                0x380
> 
> WARNING: line over 80 characters
> #24990: drivers/media/dvb-frontends/drx39xyj/drxj.c:157:
> +#define   ATV_TOP_VID_AMP_L                                                 0xF50
> 
> WARNING: line over 80 characters
> #24991: drivers/media/dvb-frontends/drx39xyj/drxj.c:158:
> +#define   ATV_TOP_VID_AMP_LP                                                0xF50
> 
> WARNING: line over 80 characters
> #24992: drivers/media/dvb-frontends/drx39xyj/drxj.c:159:
> +#define   ATV_TOP_VID_AMP_BG                                                0x380
> 
> WARNING: line over 80 characters
> #24993: drivers/media/dvb-frontends/drx39xyj/drxj.c:160:
> +#define   ATV_TOP_VID_AMP_DK                                                0x394
> 
> WARNING: line over 80 characters
> #24994: drivers/media/dvb-frontends/drx39xyj/drxj.c:161:
> +#define   ATV_TOP_VID_AMP_I                                                 0x3D8
> 
> ERROR: do not use C99 // comments
> #25006: drivers/media/dvb-frontends/drx39xyj/drxj.c:173:
> +//#define DRX_DEBUG
> 
> ERROR: spaces prohibited around that '->' (ctx:WxW)
> #25019: drivers/media/dvb-frontends/drx39xyj/drxj.c:186:
> +#define DRXJ_WAKE_UP_KEY (demod -> myI2CDevAddr -> i2cAddr)
>                                  ^
> 
> ERROR: spaces prohibited around that '->' (ctx:WxW)
> #25019: drivers/media/dvb-frontends/drx39xyj/drxj.c:186:
> +#define DRXJ_WAKE_UP_KEY (demod -> myI2CDevAddr -> i2cAddr)
>                                                  ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #25142: drivers/media/dvb-frontends/drx39xyj/drxj.c:309:
> +#define DRXJ_ATV_CHANGED_COEF          ( 0x00000001UL )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25142: drivers/media/dvb-frontends/drx39xyj/drxj.c:309:
> +#define DRXJ_ATV_CHANGED_COEF          ( 0x00000001UL )
> 
> ERROR: space prohibited after that open parenthesis '('
> #25143: drivers/media/dvb-frontends/drx39xyj/drxj.c:310:
> +#define DRXJ_ATV_CHANGED_PEAK_FLT      ( 0x00000008UL )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25143: drivers/media/dvb-frontends/drx39xyj/drxj.c:310:
> +#define DRXJ_ATV_CHANGED_PEAK_FLT      ( 0x00000008UL )
> 
> ERROR: space prohibited after that open parenthesis '('
> #25144: drivers/media/dvb-frontends/drx39xyj/drxj.c:311:
> +#define DRXJ_ATV_CHANGED_NOISE_FLT     ( 0x00000010UL )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25144: drivers/media/dvb-frontends/drx39xyj/drxj.c:311:
> +#define DRXJ_ATV_CHANGED_NOISE_FLT     ( 0x00000010UL )
> 
> ERROR: space prohibited after that open parenthesis '('
> #25145: drivers/media/dvb-frontends/drx39xyj/drxj.c:312:
> +#define DRXJ_ATV_CHANGED_OUTPUT        ( 0x00000020UL )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25145: drivers/media/dvb-frontends/drx39xyj/drxj.c:312:
> +#define DRXJ_ATV_CHANGED_OUTPUT        ( 0x00000020UL )
> 
> ERROR: space prohibited after that open parenthesis '('
> #25146: drivers/media/dvb-frontends/drx39xyj/drxj.c:313:
> +#define DRXJ_ATV_CHANGED_SIF_ATT       ( 0x00000040UL )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25146: drivers/media/dvb-frontends/drx39xyj/drxj.c:313:
> +#define DRXJ_ATV_CHANGED_SIF_ATT       ( 0x00000040UL )
> 
> WARNING: line over 80 characters
> #25189: drivers/media/dvb-frontends/drx39xyj/drxj.c:356:
> +* \brief Maximum size of buffer used to verify the microcode.Must be an even number.
> 
> ERROR: exactly one space required after that #ifdef
> #25260: drivers/media/dvb-frontends/drx39xyj/drxj.c:427:
> +#ifdef  AUD_DEM_WR_FM_MATRIX__A
> 
> ERROR: space prohibited after that open parenthesis '('
> #25316: drivers/media/dvb-frontends/drx39xyj/drxj.c:483:
> +#define CHK_ERROR( s ) \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25316: drivers/media/dvb-frontends/drx39xyj/drxj.c:483:
> +#define CHK_ERROR( s ) \
> 
> WARNING: suspect code indent for conditional statements (8, 12)
> #25317: drivers/media/dvb-frontends/drx39xyj/drxj.c:484:
> +	do{ \
> +	    if ( (s) != DRX_STS_OK ) \
> 
> ERROR: space required before the open brace '{'
> #25317: drivers/media/dvb-frontends/drx39xyj/drxj.c:484:
> +	do{ \
> 
> ERROR: that open brace { should be on the previous line
> #25318: drivers/media/dvb-frontends/drx39xyj/drxj.c:485:
> +	    if ( (s) != DRX_STS_OK ) \
> +	    { \
> 
> WARNING: suspect code indent for conditional statements (12, 12)
> #25318: drivers/media/dvb-frontends/drx39xyj/drxj.c:485:
> +	    if ( (s) != DRX_STS_OK ) \
> +	    { \
> 
> ERROR: space prohibited after that open parenthesis '('
> #25318: drivers/media/dvb-frontends/drx39xyj/drxj.c:485:
> +	    if ( (s) != DRX_STS_OK ) \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25318: drivers/media/dvb-frontends/drx39xyj/drxj.c:485:
> +	    if ( (s) != DRX_STS_OK ) \
> 
> ERROR: space required after that ',' (ctx:VxV)
> #25322: drivers/media/dvb-frontends/drx39xyj/drxj.c:489:
> +		       __FILE__,__LINE__); \
>  		               ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #25327: drivers/media/dvb-frontends/drx39xyj/drxj.c:494:
> +#define CHK_ERROR( s ) \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25327: drivers/media/dvb-frontends/drx39xyj/drxj.c:494:
> +#define CHK_ERROR( s ) \
> 
> WARNING: please, no spaces at the start of a line
> #25328: drivers/media/dvb-frontends/drx39xyj/drxj.c:495:
> +   do{ \$
> 
> WARNING: suspect code indent for conditional statements (3, 6)
> #25328: drivers/media/dvb-frontends/drx39xyj/drxj.c:495:
> +   do{ \
> +      if ( (s) != DRX_STS_OK ) { goto rw_error; } \
> 
> ERROR: space required before the open brace '{'
> #25328: drivers/media/dvb-frontends/drx39xyj/drxj.c:495:
> +   do{ \
> 
> WARNING: please, no spaces at the start of a line
> #25329: drivers/media/dvb-frontends/drx39xyj/drxj.c:496:
> +      if ( (s) != DRX_STS_OK ) { goto rw_error; } \$
> 
> ERROR: space prohibited after that open parenthesis '('
> #25329: drivers/media/dvb-frontends/drx39xyj/drxj.c:496:
> +      if ( (s) != DRX_STS_OK ) { goto rw_error; } \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25329: drivers/media/dvb-frontends/drx39xyj/drxj.c:496:
> +      if ( (s) != DRX_STS_OK ) { goto rw_error; } \
> 
> ERROR: trailing statements should be on next line
> #25329: drivers/media/dvb-frontends/drx39xyj/drxj.c:496:
> +      if ( (s) != DRX_STS_OK ) { goto rw_error; } \
> 
> WARNING: braces {} are not necessary for single statement blocks
> #25329: drivers/media/dvb-frontends/drx39xyj/drxj.c:496:
> +      if ( (s) != DRX_STS_OK ) { goto rw_error; } \
> 
> WARNING: please, no spaces at the start of a line
> #25330: drivers/media/dvb-frontends/drx39xyj/drxj.c:497:
> +   } while (0 != 0)$
> 
> ERROR: space prohibited after that open parenthesis '('
> #25333: drivers/media/dvb-frontends/drx39xyj/drxj.c:500:
> +#define CHK_ZERO( s ) \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25333: drivers/media/dvb-frontends/drx39xyj/drxj.c:500:
> +#define CHK_ZERO( s ) \
> 
> WARNING: please, no spaces at the start of a line
> #25334: drivers/media/dvb-frontends/drx39xyj/drxj.c:501:
> +   do{ \$
> 
> WARNING: suspect code indent for conditional statements (3, 6)
> #25334: drivers/media/dvb-frontends/drx39xyj/drxj.c:501:
> +   do{ \
> +      if ( (s) == 0 ) return DRX_STS_ERROR; \
> 
> ERROR: space required before the open brace '{'
> #25334: drivers/media/dvb-frontends/drx39xyj/drxj.c:501:
> +   do{ \
> 
> WARNING: please, no spaces at the start of a line
> #25335: drivers/media/dvb-frontends/drx39xyj/drxj.c:502:
> +      if ( (s) == 0 ) return DRX_STS_ERROR; \$
> 
> ERROR: space prohibited after that open parenthesis '('
> #25335: drivers/media/dvb-frontends/drx39xyj/drxj.c:502:
> +      if ( (s) == 0 ) return DRX_STS_ERROR; \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25335: drivers/media/dvb-frontends/drx39xyj/drxj.c:502:
> +      if ( (s) == 0 ) return DRX_STS_ERROR; \
> 
> ERROR: trailing statements should be on next line
> #25335: drivers/media/dvb-frontends/drx39xyj/drxj.c:502:
> +      if ( (s) == 0 ) return DRX_STS_ERROR; \
> 
> WARNING: please, no spaces at the start of a line
> #25336: drivers/media/dvb-frontends/drx39xyj/drxj.c:503:
> +   } while (0)$
> 
> WARNING: please, no spaces at the start of a line
> #25339: drivers/media/dvb-frontends/drx39xyj/drxj.c:506:
> +   do{ \$
> 
> WARNING: suspect code indent for conditional statements (3, 6)
> #25339: drivers/media/dvb-frontends/drx39xyj/drxj.c:506:
> +   do{ \
> +      u16_t dummy; \
> 
> ERROR: space required before the open brace '{'
> #25339: drivers/media/dvb-frontends/drx39xyj/drxj.c:506:
> +   do{ \
> 
> WARNING: please, no spaces at the start of a line
> #25340: drivers/media/dvb-frontends/drx39xyj/drxj.c:507:
> +      u16_t dummy; \$
> 
> WARNING: please, no spaces at the start of a line
> #25341: drivers/media/dvb-frontends/drx39xyj/drxj.c:508:
> +      RR16( demod->myI2CDevAddr, SCU_RAM_VERSION_HI__A, &dummy ); \$
> 
> ERROR: space prohibited after that open parenthesis '('
> #25341: drivers/media/dvb-frontends/drx39xyj/drxj.c:508:
> +      RR16( demod->myI2CDevAddr, SCU_RAM_VERSION_HI__A, &dummy ); \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25341: drivers/media/dvb-frontends/drx39xyj/drxj.c:508:
> +      RR16( demod->myI2CDevAddr, SCU_RAM_VERSION_HI__A, &dummy ); \
> 
> WARNING: please, no spaces at the start of a line
> #25342: drivers/media/dvb-frontends/drx39xyj/drxj.c:509:
> +   } while (0)$
> 
> ERROR: space prohibited after that open parenthesis '('
> #25344: drivers/media/dvb-frontends/drx39xyj/drxj.c:511:
> +#define WR16( dev, addr, val) \
> 
> WARNING: please, no spaces at the start of a line
> #25345: drivers/media/dvb-frontends/drx39xyj/drxj.c:512:
> +   CHK_ERROR( DRXJ_DAP.writeReg16Func( (dev), (addr), (val), 0 ) )$
> 
> ERROR: space prohibited after that open parenthesis '('
> #25345: drivers/media/dvb-frontends/drx39xyj/drxj.c:512:
> +   CHK_ERROR( DRXJ_DAP.writeReg16Func( (dev), (addr), (val), 0 ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25345: drivers/media/dvb-frontends/drx39xyj/drxj.c:512:
> +   CHK_ERROR( DRXJ_DAP.writeReg16Func( (dev), (addr), (val), 0 ) )
> 
> ERROR: space prohibited after that open parenthesis '('
> #25347: drivers/media/dvb-frontends/drx39xyj/drxj.c:514:
> +#define RR16( dev, addr, val) \
> 
> WARNING: please, no spaces at the start of a line
> #25348: drivers/media/dvb-frontends/drx39xyj/drxj.c:515:
> +   CHK_ERROR( DRXJ_DAP.readReg16Func( (dev), (addr), (val), 0 ) )$
> 
> ERROR: space prohibited after that open parenthesis '('
> #25348: drivers/media/dvb-frontends/drx39xyj/drxj.c:515:
> +   CHK_ERROR( DRXJ_DAP.readReg16Func( (dev), (addr), (val), 0 ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25348: drivers/media/dvb-frontends/drx39xyj/drxj.c:515:
> +   CHK_ERROR( DRXJ_DAP.readReg16Func( (dev), (addr), (val), 0 ) )
> 
> ERROR: space prohibited after that open parenthesis '('
> #25350: drivers/media/dvb-frontends/drx39xyj/drxj.c:517:
> +#define WR32( dev, addr, val) \
> 
> WARNING: please, no spaces at the start of a line
> #25351: drivers/media/dvb-frontends/drx39xyj/drxj.c:518:
> +   CHK_ERROR( DRXJ_DAP.writeReg32Func( (dev), (addr), (val), 0 ) )$
> 
> ERROR: space prohibited after that open parenthesis '('
> #25351: drivers/media/dvb-frontends/drx39xyj/drxj.c:518:
> +   CHK_ERROR( DRXJ_DAP.writeReg32Func( (dev), (addr), (val), 0 ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25351: drivers/media/dvb-frontends/drx39xyj/drxj.c:518:
> +   CHK_ERROR( DRXJ_DAP.writeReg32Func( (dev), (addr), (val), 0 ) )
> 
> ERROR: space prohibited after that open parenthesis '('
> #25353: drivers/media/dvb-frontends/drx39xyj/drxj.c:520:
> +#define RR32( dev, addr, val) \
> 
> WARNING: please, no spaces at the start of a line
> #25354: drivers/media/dvb-frontends/drx39xyj/drxj.c:521:
> +   CHK_ERROR( DRXJ_DAP.readReg32Func( (dev), (addr), (val), 0 ) )$
> 
> ERROR: space prohibited after that open parenthesis '('
> #25354: drivers/media/dvb-frontends/drx39xyj/drxj.c:521:
> +   CHK_ERROR( DRXJ_DAP.readReg32Func( (dev), (addr), (val), 0 ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25354: drivers/media/dvb-frontends/drx39xyj/drxj.c:521:
> +   CHK_ERROR( DRXJ_DAP.readReg32Func( (dev), (addr), (val), 0 ) )
> 
> ERROR: space prohibited after that open parenthesis '('
> #25356: drivers/media/dvb-frontends/drx39xyj/drxj.c:523:
> +#define WRB( dev, addr, len, block ) \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25356: drivers/media/dvb-frontends/drx39xyj/drxj.c:523:
> +#define WRB( dev, addr, len, block ) \
> 
> WARNING: please, no spaces at the start of a line
> #25357: drivers/media/dvb-frontends/drx39xyj/drxj.c:524:
> +   CHK_ERROR( DRXJ_DAP.writeBlockFunc( (dev), (addr), (len), (block), 0 ) )$
> 
> ERROR: space prohibited after that open parenthesis '('
> #25357: drivers/media/dvb-frontends/drx39xyj/drxj.c:524:
> +   CHK_ERROR( DRXJ_DAP.writeBlockFunc( (dev), (addr), (len), (block), 0 ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25357: drivers/media/dvb-frontends/drx39xyj/drxj.c:524:
> +   CHK_ERROR( DRXJ_DAP.writeBlockFunc( (dev), (addr), (len), (block), 0 ) )
> 
> ERROR: space prohibited after that open parenthesis '('
> #25359: drivers/media/dvb-frontends/drx39xyj/drxj.c:526:
> +#define RRB( dev, addr, len, block ) \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25359: drivers/media/dvb-frontends/drx39xyj/drxj.c:526:
> +#define RRB( dev, addr, len, block ) \
> 
> WARNING: please, no spaces at the start of a line
> #25360: drivers/media/dvb-frontends/drx39xyj/drxj.c:527:
> +   CHK_ERROR( DRXJ_DAP.readBlockFunc( (dev), (addr), (len), (block), 0 ) )$
> 
> ERROR: space prohibited after that open parenthesis '('
> #25360: drivers/media/dvb-frontends/drx39xyj/drxj.c:527:
> +   CHK_ERROR( DRXJ_DAP.readBlockFunc( (dev), (addr), (len), (block), 0 ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25360: drivers/media/dvb-frontends/drx39xyj/drxj.c:527:
> +   CHK_ERROR( DRXJ_DAP.readBlockFunc( (dev), (addr), (len), (block), 0 ) )
> 
> ERROR: space prohibited after that open parenthesis '('
> #25362: drivers/media/dvb-frontends/drx39xyj/drxj.c:529:
> +#define BCWR16( dev, addr, val ) \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25362: drivers/media/dvb-frontends/drx39xyj/drxj.c:529:
> +#define BCWR16( dev, addr, val ) \
> 
> WARNING: line over 80 characters
> #25363: drivers/media/dvb-frontends/drx39xyj/drxj.c:530:
> +   CHK_ERROR( DRXJ_DAP.writeReg16Func( (dev), (addr), (val), DRXDAP_FASI_BROADCAST ) )
> 
> WARNING: please, no spaces at the start of a line
> #25363: drivers/media/dvb-frontends/drx39xyj/drxj.c:530:
> +   CHK_ERROR( DRXJ_DAP.writeReg16Func( (dev), (addr), (val), DRXDAP_FASI_BROADCAST ) )$
> 
> ERROR: space prohibited after that open parenthesis '('
> #25363: drivers/media/dvb-frontends/drx39xyj/drxj.c:530:
> +   CHK_ERROR( DRXJ_DAP.writeReg16Func( (dev), (addr), (val), DRXDAP_FASI_BROADCAST ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25363: drivers/media/dvb-frontends/drx39xyj/drxj.c:530:
> +   CHK_ERROR( DRXJ_DAP.writeReg16Func( (dev), (addr), (val), DRXDAP_FASI_BROADCAST ) )
> 
> ERROR: space prohibited after that open parenthesis '('
> #25365: drivers/media/dvb-frontends/drx39xyj/drxj.c:532:
> +#define ARR32( dev, addr, val) \
> 
> WARNING: please, no spaces at the start of a line
> #25366: drivers/media/dvb-frontends/drx39xyj/drxj.c:533:
> +   CHK_ERROR( DRXJ_DAP_AtomicReadReg32( (dev), (addr), (val), 0 ) )$
> 
> ERROR: space prohibited after that open parenthesis '('
> #25366: drivers/media/dvb-frontends/drx39xyj/drxj.c:533:
> +   CHK_ERROR( DRXJ_DAP_AtomicReadReg32( (dev), (addr), (val), 0 ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25366: drivers/media/dvb-frontends/drx39xyj/drxj.c:533:
> +   CHK_ERROR( DRXJ_DAP_AtomicReadReg32( (dev), (addr), (val), 0 ) )
> 
> ERROR: space prohibited after that open parenthesis '('
> #25368: drivers/media/dvb-frontends/drx39xyj/drxj.c:535:
> +#define SARR16( dev, addr, val) \
> 
> WARNING: please, no spaces at the start of a line
> #25369: drivers/media/dvb-frontends/drx39xyj/drxj.c:536:
> +   CHK_ERROR( DRXJ_DAP_SCU_AtomicReadReg16( (dev), (addr), (val), 0 ) )$
> 
> ERROR: space prohibited after that open parenthesis '('
> #25369: drivers/media/dvb-frontends/drx39xyj/drxj.c:536:
> +   CHK_ERROR( DRXJ_DAP_SCU_AtomicReadReg16( (dev), (addr), (val), 0 ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25369: drivers/media/dvb-frontends/drx39xyj/drxj.c:536:
> +   CHK_ERROR( DRXJ_DAP_SCU_AtomicReadReg16( (dev), (addr), (val), 0 ) )
> 
> ERROR: space prohibited after that open parenthesis '('
> #25371: drivers/media/dvb-frontends/drx39xyj/drxj.c:538:
> +#define SAWR16( dev, addr, val) \
> 
> WARNING: please, no spaces at the start of a line
> #25372: drivers/media/dvb-frontends/drx39xyj/drxj.c:539:
> +   CHK_ERROR( DRXJ_DAP_SCU_AtomicWriteReg16( (dev), (addr), (val), 0 ) )$
> 
> ERROR: space prohibited after that open parenthesis '('
> #25372: drivers/media/dvb-frontends/drx39xyj/drxj.c:539:
> +   CHK_ERROR( DRXJ_DAP_SCU_AtomicWriteReg16( (dev), (addr), (val), 0 ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25372: drivers/media/dvb-frontends/drx39xyj/drxj.c:539:
> +   CHK_ERROR( DRXJ_DAP_SCU_AtomicWriteReg16( (dev), (addr), (val), 0 ) )
> 
> ERROR: need consistent spacing around '&' (ctx:WxV)
> #25380: drivers/media/dvb-frontends/drx39xyj/drxj.c:547:
> +#define DRXJ_16TO8( x ) ((u8_t) (((u16_t)x)    &0xFF)), \
>                                                 ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #25380: drivers/media/dvb-frontends/drx39xyj/drxj.c:547:
> +#define DRXJ_16TO8( x ) ((u8_t) (((u16_t)x)    &0xFF)), \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25380: drivers/media/dvb-frontends/drx39xyj/drxj.c:547:
> +#define DRXJ_16TO8( x ) ((u8_t) (((u16_t)x)    &0xFF)), \
> 
> ERROR: Macros with complex values should be enclosed in parenthesis
> #25380: drivers/media/dvb-frontends/drx39xyj/drxj.c:547:
> +#define DRXJ_16TO8( x ) ((u8_t) (((u16_t)x)    &0xFF)), \
> +			((u8_t)((((u16_t)x)>>8)&0xFF))
> 
> ERROR: space prohibited after that open parenthesis '('
> #25387: drivers/media/dvb-frontends/drx39xyj/drxj.c:554:
> +#define DRXJ_8TO16( x ) ((u16_t) (x[0] | (x[1] << 8)))
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25387: drivers/media/dvb-frontends/drx39xyj/drxj.c:554:
> +#define DRXJ_8TO16( x ) ((u16_t) (x[0] | (x[1] << 8)))
> 
> ERROR: space prohibited after that open parenthesis '('
> #25406: drivers/media/dvb-frontends/drx39xyj/drxj.c:573:
> +#define DRXJ_ISATVSTD( std ) ( ( std == DRX_STANDARD_PAL_SECAM_BG ) || \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25406: drivers/media/dvb-frontends/drx39xyj/drxj.c:573:
> +#define DRXJ_ISATVSTD( std ) ( ( std == DRX_STANDARD_PAL_SECAM_BG ) || \
> 
> ERROR: space prohibited after that open parenthesis '('
> #25407: drivers/media/dvb-frontends/drx39xyj/drxj.c:574:
> +			       ( std == DRX_STANDARD_PAL_SECAM_DK ) || \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25407: drivers/media/dvb-frontends/drx39xyj/drxj.c:574:
> +			       ( std == DRX_STANDARD_PAL_SECAM_DK ) || \
> 
> ERROR: space prohibited after that open parenthesis '('
> #25408: drivers/media/dvb-frontends/drx39xyj/drxj.c:575:
> +			       ( std == DRX_STANDARD_PAL_SECAM_I  ) || \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25408: drivers/media/dvb-frontends/drx39xyj/drxj.c:575:
> +			       ( std == DRX_STANDARD_PAL_SECAM_I  ) || \
> 
> ERROR: space prohibited after that open parenthesis '('
> #25409: drivers/media/dvb-frontends/drx39xyj/drxj.c:576:
> +			       ( std == DRX_STANDARD_PAL_SECAM_L  ) || \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25409: drivers/media/dvb-frontends/drx39xyj/drxj.c:576:
> +			       ( std == DRX_STANDARD_PAL_SECAM_L  ) || \
> 
> ERROR: space prohibited after that open parenthesis '('
> #25410: drivers/media/dvb-frontends/drx39xyj/drxj.c:577:
> +			       ( std == DRX_STANDARD_PAL_SECAM_LP ) || \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25410: drivers/media/dvb-frontends/drx39xyj/drxj.c:577:
> +			       ( std == DRX_STANDARD_PAL_SECAM_LP ) || \
> 
> ERROR: space prohibited after that open parenthesis '('
> #25411: drivers/media/dvb-frontends/drx39xyj/drxj.c:578:
> +			       ( std == DRX_STANDARD_NTSC ) || \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25411: drivers/media/dvb-frontends/drx39xyj/drxj.c:578:
> +			       ( std == DRX_STANDARD_NTSC ) || \
> 
> ERROR: space prohibited after that open parenthesis '('
> #25412: drivers/media/dvb-frontends/drx39xyj/drxj.c:579:
> +			       ( std == DRX_STANDARD_FM ) )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25412: drivers/media/dvb-frontends/drx39xyj/drxj.c:579:
> +			       ( std == DRX_STANDARD_FM ) )
> 
> ERROR: space prohibited after that open parenthesis '('
> #25414: drivers/media/dvb-frontends/drx39xyj/drxj.c:581:
> +#define DRXJ_ISQAMSTD( std ) ( ( std == DRX_STANDARD_ITU_A ) || \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25414: drivers/media/dvb-frontends/drx39xyj/drxj.c:581:
> +#define DRXJ_ISQAMSTD( std ) ( ( std == DRX_STANDARD_ITU_A ) || \
> 
> ERROR: space prohibited after that open parenthesis '('
> #25415: drivers/media/dvb-frontends/drx39xyj/drxj.c:582:
> +			       ( std == DRX_STANDARD_ITU_B ) || \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25415: drivers/media/dvb-frontends/drx39xyj/drxj.c:582:
> +			       ( std == DRX_STANDARD_ITU_B ) || \
> 
> ERROR: space prohibited after that open parenthesis '('
> #25416: drivers/media/dvb-frontends/drx39xyj/drxj.c:583:
> +			       ( std == DRX_STANDARD_ITU_C ) || \
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25416: drivers/media/dvb-frontends/drx39xyj/drxj.c:583:
> +			       ( std == DRX_STANDARD_ITU_C ) || \
> 
> ERROR: space prohibited after that open parenthesis '('
> #25417: drivers/media/dvb-frontends/drx39xyj/drxj.c:584:
> +			       ( std == DRX_STANDARD_ITU_D ))
> 
> ERROR: space prohibited before that close parenthesis ')'
> #25417: drivers/media/dvb-frontends/drx39xyj/drxj.c:584:
> +			       ( std == DRX_STANDARD_ITU_D ))
> 
> WARNING: externs should be avoided in .c files
> #25422: drivers/media/dvb-frontends/drx39xyj/drxj.c:589:
> +DRXStatus_t DRXJ_Open(pDRXDemodInstance_t demod);
> 
> WARNING: externs should be avoided in .c files
> #25423: drivers/media/dvb-frontends/drx39xyj/drxj.c:590:
> +DRXStatus_t DRXJ_Close(pDRXDemodInstance_t demod);
> 
> WARNING: externs should be avoided in .c files
> #25424: drivers/media/dvb-frontends/drx39xyj/drxj.c:591:
> +DRXStatus_t DRXJ_Ctrl(pDRXDemodInstance_t demod,
> 
> WARNING: line over 80 characters
> #25525: drivers/media/dvb-frontends/drx39xyj/drxj.c:692:
> +	FALSE,			/* hasLNA : TRUE if LNA (aka PGA) present      */
> 
> WARNING: line over 80 characters
> #25526: drivers/media/dvb-frontends/drx39xyj/drxj.c:693:
> +	FALSE,			/* hasOOB : TRUE if OOB supported              */
> 
> WARNING: line over 80 characters
> #25527: drivers/media/dvb-frontends/drx39xyj/drxj.c:694:
> +	FALSE,			/* hasNTSC: TRUE if NTSC supported             */
> 
> WARNING: line over 80 characters
> #25528: drivers/media/dvb-frontends/drx39xyj/drxj.c:695:
> +	FALSE,			/* hasBTSC: TRUE if BTSC supported             */
> 
> WARNING: line over 80 characters
> #25529: drivers/media/dvb-frontends/drx39xyj/drxj.c:696:
> +	FALSE,			/* hasSMATX: TRUE if SMA_TX pin is available   */
> 
> WARNING: line over 80 characters
> #25530: drivers/media/dvb-frontends/drx39xyj/drxj.c:697:
> +	FALSE,			/* hasSMARX: TRUE if SMA_RX pin is available   */
> 
> WARNING: line over 80 characters
> #25531: drivers/media/dvb-frontends/drx39xyj/drxj.c:698:
> +	FALSE,			/* hasGPIO : TRUE if GPIO pin is available     */
> 
> WARNING: line over 80 characters
> #25532: drivers/media/dvb-frontends/drx39xyj/drxj.c:699:
> +	FALSE,			/* hasIRQN : TRUE if IRQN pin is available     */
> 
> WARNING: line over 80 characters
> #25680: drivers/media/dvb-frontends/drx39xyj/drxj.c:847:
> +	 "01234567890",		/* human readable version microcode             */
> 
> WARNING: line over 80 characters
> #25681: drivers/media/dvb-frontends/drx39xyj/drxj.c:848:
> +	 "01234567890"		/* human readable version device specific code  */
> 
> WARNING: line over 80 characters
> #25684: drivers/media/dvb-frontends/drx39xyj/drxj.c:851:
> +	 {			/* DRXVersion_t for microcode                   */
> 
> WARNING: line over 80 characters
> #25791: drivers/media/dvb-frontends/drx39xyj/drxj.c:958:
> +	44000,			/* IF in kHz in case no tuner instance is used  */
> 
> WARNING: line over 80 characters
> #25792: drivers/media/dvb-frontends/drx39xyj/drxj.c:959:
> +	(151875 - 0),		/* system clock frequency in kHz                */
> 
> WARNING: line over 80 characters
> #25793: drivers/media/dvb-frontends/drx39xyj/drxj.c:960:
> +	0,			/* oscillator frequency kHz                     */
> 
> WARNING: line over 80 characters
> #25794: drivers/media/dvb-frontends/drx39xyj/drxj.c:961:
> +	0,			/* oscillator deviation in ppm, signed          */
> 
> WARNING: line over 80 characters
> #25795: drivers/media/dvb-frontends/drx39xyj/drxj.c:962:
> +	FALSE,			/* If TRUE mirror frequency spectrum            */
> 
> WARNING: line over 80 characters
> #25814: drivers/media/dvb-frontends/drx39xyj/drxj.c:981:
> +	   are initialy 0, NULL or FALSE. The compiler will initialize them to these
> 
> WARNING: do not add new typedefs
> #25944: drivers/media/dvb-frontends/drx39xyj/drxj.c:1111:
> +typedef struct {
> 
> WARNING: do not add new typedefs
> #25952: drivers/media/dvb-frontends/drx39xyj/drxj.c:1119:
> +typedef struct {
> 
> WARNING: do not add new typedefs
> #25967: drivers/media/dvb-frontends/drx39xyj/drxj.c:1134:
> +typedef struct {
> 
> WARNING: line over 80 characters
> #26039: drivers/media/dvb-frontends/drx39xyj/drxj.c:1206:
> +* of iterations. This is done by taking three subsequent bits abc and calculating
> 
> WARNING: line over 80 characters
> #26060: drivers/media/dvb-frontends/drx39xyj/drxj.c:1227:
> +#define DRX_IS_BOOTH_NEGATIVE(__a)  (((__a) & (1 << (sizeof (u32_t) * 8 - 1))) != 0)
> 
> WARNING: space prohibited between function name and open parenthesis '('
> #26060: drivers/media/dvb-frontends/drx39xyj/drxj.c:1227:
> +#define DRX_IS_BOOTH_NEGATIVE(__a)  (((__a) & (1 << (sizeof (u32_t) * 8 - 1))) != 0)
> 
> WARNING: line over 80 characters
> #26067: drivers/media/dvb-frontends/drx39xyj/drxj.c:1234:
> +	/* n/2 iterations; shift operand a left two bits after each iteration.      */
> 
> WARNING: line over 80 characters
> #26068: drivers/media/dvb-frontends/drx39xyj/drxj.c:1235:
> +	/* This automatically appends a zero to the operand for the last iteration. */
> 
> WARNING: line over 80 characters
> #26074: drivers/media/dvb-frontends/drx39xyj/drxj.c:1241:
> +		/* Take the first three bits of operand a for the Booth conversion: */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #26096: drivers/media/dvb-frontends/drx39xyj/drxj.c:1263:
> +		case 5:
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #26097: drivers/media/dvb-frontends/drx39xyj/drxj.c:1264:
> +		case 6:
> 
> WARNING: line over 80 characters
> #26138: drivers/media/dvb-frontends/drx39xyj/drxj.c:1305:
> +	Q1 = N / D;		/* integer part, only the 4 least significant bits
> 
> WARNING: line over 80 characters
> #26174: drivers/media/dvb-frontends/drx39xyj/drxj.c:1341:
> +	   log2lut[n] = (1<<scale) * 200 * log2( 1.0 + ( (1.0/(1<<INDEXWIDTH)) * n ))
> 
> ERROR: return is not a function, parentheses are not required
> #26221: drivers/media/dvb-frontends/drx39xyj/drxj.c:1388:
> +		return (0);
> 
> ERROR: return is not a function, parentheses are not required
> #26261: drivers/media/dvb-frontends/drx39xyj/drxj.c:1428:
> +	return (r);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #26293: drivers/media/dvb-frontends/drx39xyj/drxj.c:1460:
> +	if ((remainder * 2) > D) {
> +		frac++;
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #26297: drivers/media/dvb-frontends/drx39xyj/drxj.c:1464:
> +	return (frac);
> 
> ERROR: return is not a function, parentheses are not required
> #26368: drivers/media/dvb-frontends/drx39xyj/drxj.c:1535:
> +		return (frac);
> 
> WARNING: line over 80 characters
> #26392: drivers/media/dvb-frontends/drx39xyj/drxj.c:1559:
> +			/*(remainder is not zero -> value behind decimal point exists) */
> 
> ERROR: return is not a function, parentheses are not required
> #26401: drivers/media/dvb-frontends/drx39xyj/drxj.c:1568:
> +	return (frac);
> 
> ERROR: return is not a function, parentheses are not required
> #26423: drivers/media/dvb-frontends/drx39xyj/drxj.c:1590:
> +	return (word);
> 
> ERROR: return is not a function, parentheses are not required
> #26447: drivers/media/dvb-frontends/drx39xyj/drxj.c:1614:
> +	return (word);
> 
> WARNING: please, no spaces at the start of a line
> #26487: drivers/media/dvb-frontends/drx39xyj/drxj.c:1654:
> +    { 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4,$
> 
> ERROR: that open brace { should be on the previous line
> #26487: drivers/media/dvb-frontends/drx39xyj/drxj.c:1654:
> +static const u16_t NicamPrescTableVal[43] =
> +    { 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4,
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #26519: drivers/media/dvb-frontends/drx39xyj/drxj.c:1686:
> +#define DRXJ_ISAUDWRITE( addr ) (((((addr)>>16)&1)==1)?TRUE:FALSE)
>                                                    ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #26519: drivers/media/dvb-frontends/drx39xyj/drxj.c:1686:
> +#define DRXJ_ISAUDWRITE( addr ) (((((addr)>>16)&1)==1)?TRUE:FALSE)
> 
> ERROR: space prohibited before that close parenthesis ')'
> #26519: drivers/media/dvb-frontends/drx39xyj/drxj.c:1686:
> +#define DRXJ_ISAUDWRITE( addr ) (((((addr)>>16)&1)==1)?TRUE:FALSE)
> 
> ERROR: return is not a function, parentheses are not required
> #26543: drivers/media/dvb-frontends/drx39xyj/drxj.c:1710:
> +	return (retval);
> 
> ERROR: space prohibited after that open parenthesis '('
> #26591: drivers/media/dvb-frontends/drx39xyj/drxj.c:1758:
> +#if ( DRXDAPFASI_LONG_ADDR_ALLOWED == 0 )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #26591: drivers/media/dvb-frontends/drx39xyj/drxj.c:1758:
> +#if ( DRXDAPFASI_LONG_ADDR_ALLOWED == 0 )
> 
> WARNING: braces {} are not necessary for single statement blocks
> #26599: drivers/media/dvb-frontends/drx39xyj/drxj.c:1766:
> +	if (rdata == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: line over 80 characters
> #26606: drivers/media/dvb-frontends/drx39xyj/drxj.c:1773:
> +					      SIO_HI_RA_RAM_S0_FLG_ACC_S0_RWM__M,
> 
> WARNING: line over 80 characters
> #26621: drivers/media/dvb-frontends/drx39xyj/drxj.c:1788:
> +						      SIO_HI_RA_RAM_S0_FLG_ACC__A,
> 
> ERROR: spaces required around that '==' (ctx:VxV)
> #26639: drivers/media/dvb-frontends/drx39xyj/drxj.c:1806:
> +#if ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 )
>                                    ^
> 
> ERROR: space prohibited after that open parenthesis '('
> #26639: drivers/media/dvb-frontends/drx39xyj/drxj.c:1806:
> +#if ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 )
> 
> ERROR: space prohibited before that close parenthesis ')'
> #26639: drivers/media/dvb-frontends/drx39xyj/drxj.c:1806:
> +#if ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 )
> 
> WARNING: line over 80 characters
> #26705: drivers/media/dvb-frontends/drx39xyj/drxj.c:1872:
> +			/* RMW to aud TR IF until request is granted or timeout */
> 
> WARNING: line over 80 characters
> #26708: drivers/media/dvb-frontends/drx39xyj/drxj.c:1875:
> +							     SIO_HI_RA_RAM_S0_RMWBUF__A,
> 
> WARNING: braces {} are not necessary for single statement blocks
> #26771: drivers/media/dvb-frontends/drx39xyj/drxj.c:1938:
> +	if ((devAddr == NULL) || (data == NULL)) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: line over 80 characters
> #26848: drivers/media/dvb-frontends/drx39xyj/drxj.c:2015:
> +			/* RMW to aud TR IF until request is granted or timeout */
> 
> WARNING: line over 80 characters
> #26851: drivers/media/dvb-frontends/drx39xyj/drxj.c:2018:
> +							     SIO_HI_RA_RAM_S0_RMWBUF__A,
> 
> WARNING: braces {} are not necessary for single statement blocks
> #26883: drivers/media/dvb-frontends/drx39xyj/drxj.c:2050:
> +	if (devAddr == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #26945: drivers/media/dvb-frontends/drx39xyj/drxj.c:2112:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #26956: drivers/media/dvb-frontends/drx39xyj/drxj.c:2123:
> +	if (readFlag == FALSE) {
> [...]
> +	} else {
> [...]
> 
> ERROR: return is not a function, parentheses are not required
> #26993: drivers/media/dvb-frontends/drx39xyj/drxj.c:2160:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #27012: drivers/media/dvb-frontends/drx39xyj/drxj.c:2179:
> +	if (!data) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #27076: drivers/media/dvb-frontends/drx39xyj/drxj.c:2243:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #27079: drivers/media/dvb-frontends/drx39xyj/drxj.c:2246:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #27119: drivers/media/dvb-frontends/drx39xyj/drxj.c:2286:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #27152: drivers/media/dvb-frontends/drx39xyj/drxj.c:2319:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #27154: drivers/media/dvb-frontends/drx39xyj/drxj.c:2321:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #27188: drivers/media/dvb-frontends/drx39xyj/drxj.c:2355:
> +	if ((extAttr->HICfgTimingDiv) > SIO_HI_RA_RAM_PAR_2_CFG_DIV__M) {
> +		extAttr->HICfgTimingDiv = SIO_HI_RA_RAM_PAR_2_CFG_DIV__M;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #27198: drivers/media/dvb-frontends/drx39xyj/drxj.c:2365:
> +	if ((extAttr->HICfgBridgeDelay) > SIO_HI_RA_RAM_PAR_3_CFG_DBL_SDA__M) {
> +		extAttr->HICfgBridgeDelay = SIO_HI_RA_RAM_PAR_3_CFG_DBL_SDA__M;
> +	}
> 
> WARNING: line over 80 characters
> #27204: drivers/media/dvb-frontends/drx39xyj/drxj.c:2371:
> +	/* Wakeup key, setting the read flag (as suggest in the documentation) does
> 
> WARNING: line over 80 characters
> #27205: drivers/media/dvb-frontends/drx39xyj/drxj.c:2372:
> +	   not always result into a working solution (barebones worked VI2C failed).
> 
> ERROR: return is not a function, parentheses are not required
> #27215: drivers/media/dvb-frontends/drx39xyj/drxj.c:2382:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #27218: drivers/media/dvb-frontends/drx39xyj/drxj.c:2385:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #27281: drivers/media/dvb-frontends/drx39xyj/drxj.c:2448:
> +		return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #27399: drivers/media/dvb-frontends/drx39xyj/drxj.c:2566:
> +		return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #27403: drivers/media/dvb-frontends/drx39xyj/drxj.c:2570:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #27405: drivers/media/dvb-frontends/drx39xyj/drxj.c:2572:
> +	return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #27434: drivers/media/dvb-frontends/drx39xyj/drxj.c:2601:
> +	   dummy write must be used to wake uop device, dummy read must be used to
> 
> WARNING: braces {} are not necessary for single statement blocks
> #27451: drivers/media/dvb-frontends/drx39xyj/drxj.c:2618:
> +	if (retryCount == DRXJ_MAX_RETRIES_POWERUP) {
> +		return (DRX_STS_ERROR);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #27452: drivers/media/dvb-frontends/drx39xyj/drxj.c:2619:
> +		return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #27455: drivers/media/dvb-frontends/drx39xyj/drxj.c:2622:
> +	return (DRX_STS_OK);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #27491: drivers/media/dvb-frontends/drx39xyj/drxj.c:2658:
> +	if ((demod == NULL) || (cfgData == NULL)) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #27492: drivers/media/dvb-frontends/drx39xyj/drxj.c:2659:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #27523: drivers/media/dvb-frontends/drx39xyj/drxj.c:2690:
> +			return (DRX_STS_OK);
> 
> WARNING: line over 80 characters
> #27529: drivers/media/dvb-frontends/drx39xyj/drxj.c:2696:
> +			WR16(devAddr, FEC_OC_FCT_USAGE__A, 7);	/* 2048 bytes fifo ram */
> 
> ERROR: return is not a function, parentheses are not required
> #27559: drivers/media/dvb-frontends/drx39xyj/drxj.c:2726:
> +				return (DRX_STS_ERROR);
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #27566: drivers/media/dvb-frontends/drx39xyj/drxj.c:2733:
> +		case DRX_STANDARD_ITU_B:
> 
> ERROR: return is not a function, parentheses are not required
> #27611: drivers/media/dvb-frontends/drx39xyj/drxj.c:2778:
> +					return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #27616: drivers/media/dvb-frontends/drx39xyj/drxj.c:2783:
> +				/* insertRSByte = TRUE -> coef = 188/188 -> 1, RS bits are in MPEG output */
> 
> ERROR: return is not a function, parentheses are not required
> #27624: drivers/media/dvb-frontends/drx39xyj/drxj.c:2791:
> +				return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #27646: drivers/media/dvb-frontends/drx39xyj/drxj.c:2813:
> +					return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #27651: drivers/media/dvb-frontends/drx39xyj/drxj.c:2818:
> +				/* insertRSByte = FALSE -> coef = 188/204, RS bits not in MPEG output */
> 
> ERROR: return is not a function, parentheses are not required
> #27659: drivers/media/dvb-frontends/drx39xyj/drxj.c:2826:
> +				return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #27663: drivers/media/dvb-frontends/drx39xyj/drxj.c:2830:
> +		if (cfgData->enableParallel == TRUE) {	/* MPEG data output is paralel -> clear ipr_mode[0] */
> 
> WARNING: line over 80 characters
> #27665: drivers/media/dvb-frontends/drx39xyj/drxj.c:2832:
> +		} else {	/* MPEG data output is serial -> set ipr_mode[0] */
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #27670: drivers/media/dvb-frontends/drx39xyj/drxj.c:2837:
> +		if (cfgData->invertDATA == TRUE) {
> [...]
> +		} else {
> [...]
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #27676: drivers/media/dvb-frontends/drx39xyj/drxj.c:2843:
> +		if (cfgData->invertERR == TRUE) {
> [...]
> +		} else {
> [...]
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #27682: drivers/media/dvb-frontends/drx39xyj/drxj.c:2849:
> +		if (cfgData->invertSTR == TRUE) {
> [...]
> +		} else {
> [...]
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #27688: drivers/media/dvb-frontends/drx39xyj/drxj.c:2855:
> +		if (cfgData->invertVAL == TRUE) {
> [...]
> +		} else {
> [...]
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #27694: drivers/media/dvb-frontends/drx39xyj/drxj.c:2861:
> +		if (cfgData->invertCLK == TRUE) {
> [...]
> +		} else {
> [...]
> 
> WARNING: braces {} are not necessary for single statement blocks
> #27711: drivers/media/dvb-frontends/drx39xyj/drxj.c:2878:
> +				if (cfgData->insertRSByte == TRUE) {
> +					fecOcDtoBurstLen = 208;
> +				}
> 
> WARNING: Missing a blank line after declarations
> #27718: drivers/media/dvb-frontends/drx39xyj/drxj.c:2885:
> +					u32_t symbolRateTh = 6400000;
> +					if (cfgData->insertRSByte == TRUE) {
> 
> WARNING: braces {} are not necessary for single statement blocks
> #27732: drivers/media/dvb-frontends/drx39xyj/drxj.c:2899:
> +				if (cfgData->insertRSByte == TRUE) {
> +					fecOcDtoBurstLen = 128;
> +				}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #27738: drivers/media/dvb-frontends/drx39xyj/drxj.c:2905:
> +				if (cfgData->insertRSByte == TRUE) {
> +					fecOcDtoBurstLen = 204;
> +				}
> 
> ERROR: return is not a function, parentheses are not required
> #27743: drivers/media/dvb-frontends/drx39xyj/drxj.c:2910:
> +				return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #27796: drivers/media/dvb-frontends/drx39xyj/drxj.c:2963:
> +		if (cfgData->enableParallel == TRUE) {	/* MPEG data output is paralel -> set MD1 to MD7 to output mode */
> 
> WARNING: line over 80 characters
> #27809: drivers/media/dvb-frontends/drx39xyj/drxj.c:2976:
> +		} else {	/* MPEG data output is serial -> set MD1 to MD7 to tri-state */
> 
> ERROR: return is not a function, parentheses are not required
> #27856: drivers/media/dvb-frontends/drx39xyj/drxj.c:3023:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #27858: drivers/media/dvb-frontends/drx39xyj/drxj.c:3025:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #27883: drivers/media/dvb-frontends/drx39xyj/drxj.c:3050:
> +	if (cfgData == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #27884: drivers/media/dvb-frontends/drx39xyj/drxj.c:3051:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: Unnecessary parentheses - maybe == should be = ?
> #27901: drivers/media/dvb-frontends/drx39xyj/drxj.c:3068:
> +	if ((lockStatus == DRX_LOCKED)) {
> 
> ERROR: return is not a function, parentheses are not required
> #27909: drivers/media/dvb-frontends/drx39xyj/drxj.c:3076:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #27911: drivers/media/dvb-frontends/drx39xyj/drxj.c:3078:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #27964: drivers/media/dvb-frontends/drx39xyj/drxj.c:3131:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #27966: drivers/media/dvb-frontends/drx39xyj/drxj.c:3133:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #28000: drivers/media/dvb-frontends/drx39xyj/drxj.c:3167:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #28002: drivers/media/dvb-frontends/drx39xyj/drxj.c:3169:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #28028: drivers/media/dvb-frontends/drx39xyj/drxj.c:3195:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #28030: drivers/media/dvb-frontends/drx39xyj/drxj.c:3197:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28058: drivers/media/dvb-frontends/drx39xyj/drxj.c:3225:
> +		if (extAttr->mpegStartWidth == DRXJ_MPEG_START_WIDTH_8CLKCYC) {
> +			fecOcCommMb |= FEC_OC_COMM_MB_CTL_ON;
> +		}
> 
> ERROR: return is not a function, parentheses are not required
> #28064: drivers/media/dvb-frontends/drx39xyj/drxj.c:3231:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #28066: drivers/media/dvb-frontends/drx39xyj/drxj.c:3233:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28087: drivers/media/dvb-frontends/drx39xyj/drxj.c:3254:
> +	if (cfgData == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #28088: drivers/media/dvb-frontends/drx39xyj/drxj.c:3255:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: line over 80 characters
> #28095: drivers/media/dvb-frontends/drx39xyj/drxj.c:3262:
> +	   TEI must be left untouched by device in case of BER measurements using
> 
> WARNING: line over 80 characters
> #28098: drivers/media/dvb-frontends/drx39xyj/drxj.c:3265:
> +	   Reverse output bit order. Default is FALSE (msb on MD7 (parallel) or out first (serial)).
> 
> WARNING: line over 80 characters
> #28100: drivers/media/dvb-frontends/drx39xyj/drxj.c:3267:
> +	   The flags and values will also be used to set registers during a set channel.
> 
> WARNING: line over 80 characters
> #28106: drivers/media/dvb-frontends/drx39xyj/drxj.c:3273:
> +	/* Don't care what the active standard is, activate setting immediatly */
> 
> ERROR: return is not a function, parentheses are not required
> #28112: drivers/media/dvb-frontends/drx39xyj/drxj.c:3279:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #28114: drivers/media/dvb-frontends/drx39xyj/drxj.c:3281:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28138: drivers/media/dvb-frontends/drx39xyj/drxj.c:3305:
> +	if (cfgData == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #28139: drivers/media/dvb-frontends/drx39xyj/drxj.c:3306:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #28154: drivers/media/dvb-frontends/drx39xyj/drxj.c:3321:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #28156: drivers/media/dvb-frontends/drx39xyj/drxj.c:3323:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28179: drivers/media/dvb-frontends/drx39xyj/drxj.c:3346:
> +	if (cfgData == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #28180: drivers/media/dvb-frontends/drx39xyj/drxj.c:3347:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #28191: drivers/media/dvb-frontends/drx39xyj/drxj.c:3358:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #28193: drivers/media/dvb-frontends/drx39xyj/drxj.c:3360:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28214: drivers/media/dvb-frontends/drx39xyj/drxj.c:3381:
> +	if ((UIOCfg == NULL) || (demod == NULL)) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #28310: drivers/media/dvb-frontends/drx39xyj/drxj.c:3477:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #28312: drivers/media/dvb-frontends/drx39xyj/drxj.c:3479:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28342: drivers/media/dvb-frontends/drx39xyj/drxj.c:3509:
> +	if (UIOCfg == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28346: drivers/media/dvb-frontends/drx39xyj/drxj.c:3513:
> +	if ((UIOCfg->uio > DRX_UIO4) || (UIOCfg->uio < DRX_UIO1)) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28350: drivers/media/dvb-frontends/drx39xyj/drxj.c:3517:
> +	if (*UIOAvailable[UIOCfg->uio] == FALSE) {
> +		return DRX_STS_ERROR;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28373: drivers/media/dvb-frontends/drx39xyj/drxj.c:3540:
> +	if ((UIOData == NULL) || (demod == NULL)) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: line over 80 characters
> #28392: drivers/media/dvb-frontends/drx39xyj/drxj.c:3559:
> +		/* io_pad_cfg register (8 bit reg.) MSB bit is 1 (default value) */
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #28402: drivers/media/dvb-frontends/drx39xyj/drxj.c:3569:
> +		if (UIOData->value == FALSE) {
> [...]
> +		} else {
> [...]
> 
> WARNING: line over 80 characters
> #28403: drivers/media/dvb-frontends/drx39xyj/drxj.c:3570:
> +			value &= 0x7FFF;	/* write zero to 15th bit - 1st UIO */
> 
> WARNING: line over 80 characters
> #28405: drivers/media/dvb-frontends/drx39xyj/drxj.c:3572:
> +			value |= 0x8000;	/* write one to 15th bit - 1st UIO */
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28415: drivers/media/dvb-frontends/drx39xyj/drxj.c:3582:
> +		if (extAttr->uioSmaRxMode != DRX_UIO_MODE_READWRITE) {
> +			return DRX_STS_ERROR;
> +		}
> 
> WARNING: line over 80 characters
> #28419: drivers/media/dvb-frontends/drx39xyj/drxj.c:3586:
> +		/* io_pad_cfg register (8 bit reg.) MSB bit is 1 (default value) */
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #28429: drivers/media/dvb-frontends/drx39xyj/drxj.c:3596:
> +		if (UIOData->value == FALSE) {
> [...]
> +		} else {
> [...]
> 
> WARNING: line over 80 characters
> #28430: drivers/media/dvb-frontends/drx39xyj/drxj.c:3597:
> +			value &= 0xBFFF;	/* write zero to 14th bit - 2nd UIO */
> 
> WARNING: line over 80 characters
> #28432: drivers/media/dvb-frontends/drx39xyj/drxj.c:3599:
> +			value |= 0x4000;	/* write one to 14th bit - 2nd UIO */
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28442: drivers/media/dvb-frontends/drx39xyj/drxj.c:3609:
> +		if (extAttr->uioGPIOMode != DRX_UIO_MODE_READWRITE) {
> +			return DRX_STS_ERROR;
> +		}
> 
> WARNING: line over 80 characters
> #28446: drivers/media/dvb-frontends/drx39xyj/drxj.c:3613:
> +		/* io_pad_cfg register (8 bit reg.) MSB bit is 1 (default value) */
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #28456: drivers/media/dvb-frontends/drx39xyj/drxj.c:3623:
> +		if (UIOData->value == FALSE) {
> [...]
> +		} else {
> [...]
> 
> WARNING: line over 80 characters
> #28457: drivers/media/dvb-frontends/drx39xyj/drxj.c:3624:
> +			value &= 0xFFFB;	/* write zero to 2nd bit - 3rd UIO */
> 
> WARNING: line over 80 characters
> #28459: drivers/media/dvb-frontends/drx39xyj/drxj.c:3626:
> +			value |= 0x0004;	/* write one to 2nd bit - 3rd UIO */
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28470: drivers/media/dvb-frontends/drx39xyj/drxj.c:3637:
> +		if (extAttr->uioIRQNMode != DRX_UIO_MODE_READWRITE) {
> +			return DRX_STS_ERROR;
> +		}
> 
> WARNING: line over 80 characters
> #28474: drivers/media/dvb-frontends/drx39xyj/drxj.c:3641:
> +		/* io_pad_cfg register (8 bit reg.) MSB bit is 1 (default value) */
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #28484: drivers/media/dvb-frontends/drx39xyj/drxj.c:3651:
> +		if (UIOData->value == FALSE) {
> [...]
> +		} else {
> [...]
> 
> WARNING: line over 80 characters
> #28485: drivers/media/dvb-frontends/drx39xyj/drxj.c:3652:
> +			value &= 0xEFFF;	/* write zero to 12th bit - 4th UIO */
> 
> WARNING: line over 80 characters
> #28487: drivers/media/dvb-frontends/drx39xyj/drxj.c:3654:
> +			value |= 0x1000;	/* write one to 12th bit - 4th UIO */
> 
> ERROR: return is not a function, parentheses are not required
> #28500: drivers/media/dvb-frontends/drx39xyj/drxj.c:3667:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #28502: drivers/media/dvb-frontends/drx39xyj/drxj.c:3669:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28518: drivers/media/dvb-frontends/drx39xyj/drxj.c:3685:
> +	if ((UIOData == NULL) || (demod == NULL)) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28533: drivers/media/dvb-frontends/drx39xyj/drxj.c:3700:
> +		if (extAttr->uioSmaTxMode != DRX_UIO_MODE_READWRITE) {
> +			return DRX_STS_ERROR;
> +		}
> 
> WARNING: line over 80 characters
> #28537: drivers/media/dvb-frontends/drx39xyj/drxj.c:3704:
> +		/* io_pad_cfg register (8 bit reg.) MSB bit is 1 (default value) */
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28558: drivers/media/dvb-frontends/drx39xyj/drxj.c:3725:
> +		if (extAttr->uioSmaRxMode != DRX_UIO_MODE_READWRITE) {
> +			return DRX_STS_ERROR;
> +		}
> 
> WARNING: line over 80 characters
> #28562: drivers/media/dvb-frontends/drx39xyj/drxj.c:3729:
> +		/* io_pad_cfg register (8 bit reg.) MSB bit is 1 (default value) */
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28584: drivers/media/dvb-frontends/drx39xyj/drxj.c:3751:
> +		if (extAttr->uioGPIOMode != DRX_UIO_MODE_READWRITE) {
> +			return DRX_STS_ERROR;
> +		}
> 
> WARNING: line over 80 characters
> #28588: drivers/media/dvb-frontends/drx39xyj/drxj.c:3755:
> +		/* io_pad_cfg register (8 bit reg.) MSB bit is 1 (default value) */
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28610: drivers/media/dvb-frontends/drx39xyj/drxj.c:3777:
> +		if (extAttr->uioIRQNMode != DRX_UIO_MODE_READWRITE) {
> +			return DRX_STS_ERROR;
> +		}
> 
> WARNING: line over 80 characters
> #28614: drivers/media/dvb-frontends/drx39xyj/drxj.c:3781:
> +		/* io_pad_cfg register (8 bit reg.) MSB bit is 1 (default value) */
> 
> ERROR: return is not a function, parentheses are not required
> #28638: drivers/media/dvb-frontends/drx39xyj/drxj.c:3805:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #28640: drivers/media/dvb-frontends/drx39xyj/drxj.c:3807:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28665: drivers/media/dvb-frontends/drx39xyj/drxj.c:3832:
> +	if (bridgeClosed == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #28666: drivers/media/dvb-frontends/drx39xyj/drxj.c:3833:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #28671: drivers/media/dvb-frontends/drx39xyj/drxj.c:3838:
> +	if (*bridgeClosed == TRUE) {
> [...]
> +	} else {
> [...]
> 
> ERROR: return is not a function, parentheses are not required
> #28725: drivers/media/dvb-frontends/drx39xyj/drxj.c:3892:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #28727: drivers/media/dvb-frontends/drx39xyj/drxj.c:3894:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28750: drivers/media/dvb-frontends/drx39xyj/drxj.c:3917:
> +	if (smartAnt == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #28751: drivers/media/dvb-frontends/drx39xyj/drxj.c:3918:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: line over 80 characters
> #28768: drivers/media/dvb-frontends/drx39xyj/drxj.c:3935:
> +		   WR16( devAddr, SIO_SA_TX_COMMAND__A, data | SIO_SA_TX_COMMAND_TX_ENABLE__M );
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28777: drivers/media/dvb-frontends/drx39xyj/drxj.c:3944:
> +		if (data & SIO_SA_TX_STATUS_BUSY__M) {
> +			return (DRX_STS_ERROR);
> +		}
> 
> ERROR: return is not a function, parentheses are not required
> #28778: drivers/media/dvb-frontends/drx39xyj/drxj.c:3945:
> +			return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #28812: drivers/media/dvb-frontends/drx39xyj/drxj.c:3979:
> +		   WR16( devAddr, SIO_SA_TX_COMMAND__A, data & (~SIO_SA_TX_COMMAND_TX_ENABLE__M) );
> 
> ERROR: return is not a function, parentheses are not required
> #28815: drivers/media/dvb-frontends/drx39xyj/drxj.c:3982:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #28820: drivers/media/dvb-frontends/drx39xyj/drxj.c:3987:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #28822: drivers/media/dvb-frontends/drx39xyj/drxj.c:3989:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #28832: drivers/media/dvb-frontends/drx39xyj/drxj.c:3999:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28836: drivers/media/dvb-frontends/drx39xyj/drxj.c:4003:
> +	if (curCmd != DRX_SCU_READY) {
> +		return (DRX_STS_ERROR);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #28837: drivers/media/dvb-frontends/drx39xyj/drxj.c:4004:
> +		return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #28842: drivers/media/dvb-frontends/drx39xyj/drxj.c:4009:
> +		WR16(devAddr, SCU_RAM_PARAM_4__A, *(cmd->parameter + 4));	/* fallthrough */
> 
> WARNING: line over 80 characters
> #28844: drivers/media/dvb-frontends/drx39xyj/drxj.c:4011:
> +		WR16(devAddr, SCU_RAM_PARAM_3__A, *(cmd->parameter + 3));	/* fallthrough */
> 
> WARNING: line over 80 characters
> #28846: drivers/media/dvb-frontends/drx39xyj/drxj.c:4013:
> +		WR16(devAddr, SCU_RAM_PARAM_2__A, *(cmd->parameter + 2));	/* fallthrough */
> 
> WARNING: line over 80 characters
> #28848: drivers/media/dvb-frontends/drx39xyj/drxj.c:4015:
> +		WR16(devAddr, SCU_RAM_PARAM_1__A, *(cmd->parameter + 1));	/* fallthrough */
> 
> WARNING: line over 80 characters
> #28850: drivers/media/dvb-frontends/drx39xyj/drxj.c:4017:
> +		WR16(devAddr, SCU_RAM_PARAM_0__A, *(cmd->parameter + 0));	/* fallthrough */
> 
> ERROR: return is not a function, parentheses are not required
> #28856: drivers/media/dvb-frontends/drx39xyj/drxj.c:4023:
> +		return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #28867: drivers/media/dvb-frontends/drx39xyj/drxj.c:4034:
> +	if (curCmd != DRX_SCU_READY) {
> +		return (DRX_STS_ERROR);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #28868: drivers/media/dvb-frontends/drx39xyj/drxj.c:4035:
> +		return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #28877: drivers/media/dvb-frontends/drx39xyj/drxj.c:4044:
> +			RR16(devAddr, SCU_RAM_PARAM_3__A, cmd->result + 3);	/* fallthrough */
> 
> WARNING: line over 80 characters
> #28879: drivers/media/dvb-frontends/drx39xyj/drxj.c:4046:
> +			RR16(devAddr, SCU_RAM_PARAM_2__A, cmd->result + 2);	/* fallthrough */
> 
> WARNING: line over 80 characters
> #28881: drivers/media/dvb-frontends/drx39xyj/drxj.c:4048:
> +			RR16(devAddr, SCU_RAM_PARAM_1__A, cmd->result + 1);	/* fallthrough */
> 
> WARNING: line over 80 characters
> #28883: drivers/media/dvb-frontends/drx39xyj/drxj.c:4050:
> +			RR16(devAddr, SCU_RAM_PARAM_0__A, cmd->result + 0);	/* fallthrough */
> 
> ERROR: return is not a function, parentheses are not required
> #28889: drivers/media/dvb-frontends/drx39xyj/drxj.c:4056:
> +			return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #28903: drivers/media/dvb-frontends/drx39xyj/drxj.c:4070:
> +		/* here it is assumed that negative means error, and positive no error */
> 
> ERROR: return is not a function, parentheses are not required
> #28911: drivers/media/dvb-frontends/drx39xyj/drxj.c:4078:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #28914: drivers/media/dvb-frontends/drx39xyj/drxj.c:4081:
> +	return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #28931: drivers/media/dvb-frontends/drx39xyj/drxj.c:4098:
> +DRXStatus_t DRXJ_DAP_SCU_AtomicReadWriteBlock(pI2CDeviceAddr_t devAddr, DRXaddr_t addr, u16_t datasize,	/* max 30 bytes because the limit of SCU parameter */
> 
> ERROR: return is not a function, parentheses are not required
> #28942: drivers/media/dvb-frontends/drx39xyj/drxj.c:4109:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #28981: drivers/media/dvb-frontends/drx39xyj/drxj.c:4148:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #29000: drivers/media/dvb-frontends/drx39xyj/drxj.c:4167:
> +	if (!data) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #29037: drivers/media/dvb-frontends/drx39xyj/drxj.c:4204:
> +	return (DRX_STS_FUNC_NOT_AVAILABLE);
> 
> ERROR: that open brace { should be on the previous line
> #29049: drivers/media/dvb-frontends/drx39xyj/drxj.c:4216:
> +	DRXI2CData_t i2cData =
> +	    { 2, wDevAddr, wCount, wData, rDevAddr, rCount, rData };
> 
> ERROR: return is not a function, parentheses are not required
> #29053: drivers/media/dvb-frontends/drx39xyj/drxj.c:4220:
> +	return (CtrlI2CWriteRead(demod, &i2cData));
> 
> WARNING: braces {} are not necessary for single statement blocks
> #29082: drivers/media/dvb-frontends/drx39xyj/drxj.c:4249:
> +	if (data == 127) {
> +		*count = *count + 1;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #29086: drivers/media/dvb-frontends/drx39xyj/drxj.c:4253:
> +	if (data == 127) {
> +		*count = *count + 1;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #29090: drivers/media/dvb-frontends/drx39xyj/drxj.c:4257:
> +	if (data == 127) {
> +		*count = *count + 1;
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #29094: drivers/media/dvb-frontends/drx39xyj/drxj.c:4261:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #29096: drivers/media/dvb-frontends/drx39xyj/drxj.c:4263:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #29134: drivers/media/dvb-frontends/drx39xyj/drxj.c:4301:
> +		return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #29137: drivers/media/dvb-frontends/drx39xyj/drxj.c:4304:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #29139: drivers/media/dvb-frontends/drx39xyj/drxj.c:4306:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #29176: drivers/media/dvb-frontends/drx39xyj/drxj.c:4343:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #29178: drivers/media/dvb-frontends/drx39xyj/drxj.c:4345:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #29198: drivers/media/dvb-frontends/drx39xyj/drxj.c:4365:
> +	if (enable == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #29199: drivers/media/dvb-frontends/drx39xyj/drxj.c:4366:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: line over 80 characters
> #29249: drivers/media/dvb-frontends/drx39xyj/drxj.c:4416:
> +		/*  PD_RF_AGC   Analog DAC outputs, cannot be set to input or tristate!
> 
> WARNING: line over 80 characters
> #29250: drivers/media/dvb-frontends/drx39xyj/drxj.c:4417:
> +		   PD_IF_AGC   Analog DAC outputs, cannot be set to input or tristate! */
> 
> WARNING: line over 80 characters
> #29290: drivers/media/dvb-frontends/drx39xyj/drxj.c:4457:
> +		   No need to restore; will be restored in SetStandard/SetChannel */
> 
> WARNING: line over 80 characters
> #29293: drivers/media/dvb-frontends/drx39xyj/drxj.c:4460:
> +		   No need to restore; will be restored in SetStandard/SetChannel */
> 
> ERROR: return is not a function, parentheses are not required
> #29303: drivers/media/dvb-frontends/drx39xyj/drxj.c:4470:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #29306: drivers/media/dvb-frontends/drx39xyj/drxj.c:4473:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #29322: drivers/media/dvb-frontends/drx39xyj/drxj.c:4489:
> +	if (enabled == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #29323: drivers/media/dvb-frontends/drx39xyj/drxj.c:4490:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #29329: drivers/media/dvb-frontends/drx39xyj/drxj.c:4496:
> +	return (DRX_STS_OK);
> 
> WARNING: Missing a blank line after declarations
> #29407: drivers/media/dvb-frontends/drx39xyj/drxj.c:4574:
> +	u16_t agcIf = 0;
> +	devAddr = demod->myI2CDevAddr;
> 
> ERROR: return is not a function, parentheses are not required
> #29529: drivers/media/dvb-frontends/drx39xyj/drxj.c:4696:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: line over 80 characters
> #29534: drivers/media/dvb-frontends/drx39xyj/drxj.c:4701:
> +	WR16(devAddr, SCU_RAM_AGC_INGAIN__A, pAgcIfSettings->top);	/* Gain fed from inner to outer AGC */
> 
> WARNING: line over 80 characters
> #29537: drivers/media/dvb-frontends/drx39xyj/drxj.c:4704:
> +	WR16(devAddr, SCU_RAM_AGC_IF_IACCU_HI__A, 0);	/* set to pAgcSettings->top before */
> 
> WARNING: braces {} are not necessary for single statement blocks
> #29561: drivers/media/dvb-frontends/drx39xyj/drxj.c:4728:
> +	if (commonAttr->tunerRfAgcPol == TRUE) {
> +		agcRf = 0x87ff - agcRf;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #29566: drivers/media/dvb-frontends/drx39xyj/drxj.c:4733:
> +	if (commonAttr->tunerIfAgcPol == TRUE) {
> +		agcRf = 0x87ff - agcRf;
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #29579: drivers/media/dvb-frontends/drx39xyj/drxj.c:4746:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #29581: drivers/media/dvb-frontends/drx39xyj/drxj.c:4748:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #29644: drivers/media/dvb-frontends/drx39xyj/drxj.c:4811:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #29681: drivers/media/dvb-frontends/drx39xyj/drxj.c:4848:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #29683: drivers/media/dvb-frontends/drx39xyj/drxj.c:4850:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #29744: drivers/media/dvb-frontends/drx39xyj/drxj.c:4911:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #29746: drivers/media/dvb-frontends/drx39xyj/drxj.c:4913:
> +	return (DRX_STS_ERROR);
> 
> ERROR: do not initialise statics to 0 or NULL
> #29762: drivers/media/dvb-frontends/drx39xyj/drxj.c:4929:
> +	static u16_t pktErr = 0;
> 
> ERROR: do not initialise statics to 0 or NULL
> #29763: drivers/media/dvb-frontends/drx39xyj/drxj.c:4930:
> +	static u16_t lastPktErr = 0;
> 
> ERROR: return is not a function, parentheses are not required
> #29787: drivers/media/dvb-frontends/drx39xyj/drxj.c:4954:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #29789: drivers/media/dvb-frontends/drx39xyj/drxj.c:4956:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #29812: drivers/media/dvb-frontends/drx39xyj/drxj.c:4979:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #29815: drivers/media/dvb-frontends/drx39xyj/drxj.c:4982:
> +	return (DRX_STS_ERROR);
> 
> ERROR: "foo * bar" should be "foo *bar"
> #29823: drivers/media/dvb-frontends/drx39xyj/drxj.c:4990:
> +static DRXStatus_t GetSTRFreqOffset(pDRXDemodInstance_t demod, s32_t * STRFreq)
> 
> ERROR: return is not a function, parentheses are not required
> #29851: drivers/media/dvb-frontends/drx39xyj/drxj.c:5018:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #29853: drivers/media/dvb-frontends/drx39xyj/drxj.c:5020:
> +	return (DRX_STS_ERROR);
> 
> ERROR: "foo * bar" should be "foo *bar"
> #29861: drivers/media/dvb-frontends/drx39xyj/drxj.c:5028:
> +static DRXStatus_t GetCTLFreqOffset(pDRXDemodInstance_t demod, s32_t * CTLFreq)
> 
> ERROR: space prohibited after that '&' (ctx:WxW)
> #29882: drivers/media/dvb-frontends/drx39xyj/drxj.c:5049:
> +	ARR32(devAddr, IQM_FS_RATE_LO__A, (pu32_t) & currentFrequency);
>  	                                           ^
> 
> ERROR: return is not a function, parentheses are not required
> #29903: drivers/media/dvb-frontends/drx39xyj/drxj.c:5070:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #29905: drivers/media/dvb-frontends/drx39xyj/drxj.c:5072:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #29959: drivers/media/dvb-frontends/drx39xyj/drxj.c:5126:
> +			if (extAttr->standard == DRX_STANDARD_8VSB) {
> [...]
> +			} else if (DRXJ_ISQAMSTD(extAttr->standard)) {
> [...]
> +			} else {
> [...]
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #29967: drivers/media/dvb-frontends/drx39xyj/drxj.c:5134:
> +			if (commonAttr->tunerRfAgcPol) {
> [...]
> +			} else {
> [...]
> 
> ERROR: return is not a function, parentheses are not required
> #29994: drivers/media/dvb-frontends/drx39xyj/drxj.c:5161:
> +				return (DRX_STS_INVALID_ARG);
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #30024: drivers/media/dvb-frontends/drx39xyj/drxj.c:5191:
> +			if (commonAttr->tunerRfAgcPol) {
> [...]
> +			} else {
> [...]
> 
> ERROR: return is not a function, parentheses are not required
> #30052: drivers/media/dvb-frontends/drx39xyj/drxj.c:5219:
> +			return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #30080: drivers/media/dvb-frontends/drx39xyj/drxj.c:5247:
> +		return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #30083: drivers/media/dvb-frontends/drx39xyj/drxj.c:5250:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #30085: drivers/media/dvb-frontends/drx39xyj/drxj.c:5252:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #30130: drivers/media/dvb-frontends/drx39xyj/drxj.c:5297:
> +		return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #30144: drivers/media/dvb-frontends/drx39xyj/drxj.c:5311:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #30146: drivers/media/dvb-frontends/drx39xyj/drxj.c:5313:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #30198: drivers/media/dvb-frontends/drx39xyj/drxj.c:5365:
> +			if (extAttr->standard == DRX_STANDARD_8VSB) {
> [...]
> +			} else if (DRXJ_ISQAMSTD(extAttr->standard)) {
> [...]
> +			} else {
> [...]
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #30206: drivers/media/dvb-frontends/drx39xyj/drxj.c:5373:
> +			if (commonAttr->tunerIfAgcPol) {
> [...]
> +			} else {
> [...]
> 
> ERROR: return is not a function, parentheses are not required
> #30233: drivers/media/dvb-frontends/drx39xyj/drxj.c:5400:
> +				return (DRX_STS_INVALID_ARG);
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #30269: drivers/media/dvb-frontends/drx39xyj/drxj.c:5436:
> +			if (commonAttr->tunerIfAgcPol) {
> [...]
> +			} else {
> [...]
> 
> ERROR: return is not a function, parentheses are not required
> #30299: drivers/media/dvb-frontends/drx39xyj/drxj.c:5466:
> +			return (DRX_STS_INVALID_ARG);
> 
> WARNING: line over 80 characters
> #30302: drivers/media/dvb-frontends/drx39xyj/drxj.c:5469:
> +		/* always set the top to support configurations without if-loop */
> 
> ERROR: return is not a function, parentheses are not required
> #30332: drivers/media/dvb-frontends/drx39xyj/drxj.c:5499:
> +		return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #30335: drivers/media/dvb-frontends/drx39xyj/drxj.c:5502:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #30337: drivers/media/dvb-frontends/drx39xyj/drxj.c:5504:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #30382: drivers/media/dvb-frontends/drx39xyj/drxj.c:5549:
> +		return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #30397: drivers/media/dvb-frontends/drx39xyj/drxj.c:5564:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #30399: drivers/media/dvb-frontends/drx39xyj/drxj.c:5566:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #30435: drivers/media/dvb-frontends/drx39xyj/drxj.c:5602:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #30437: drivers/media/dvb-frontends/drx39xyj/drxj.c:5604:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #30501: drivers/media/dvb-frontends/drx39xyj/drxj.c:5668:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #30503: drivers/media/dvb-frontends/drx39xyj/drxj.c:5670:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #30710: drivers/media/dvb-frontends/drx39xyj/drxj.c:5877:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #30712: drivers/media/dvb-frontends/drx39xyj/drxj.c:5879:
> +	return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #30806: drivers/media/dvb-frontends/drx39xyj/drxj.c:5973:
> +	WR16(devAddr, VSB_TOP_BNTHRESH__A, 330);	/* set higher threshold */
> 
> WARNING: line over 80 characters
> #30807: drivers/media/dvb-frontends/drx39xyj/drxj.c:5974:
> +	WR16(devAddr, VSB_TOP_CLPLASTNUM__A, 90);	/* burst detection on   */
> 
> WARNING: line over 80 characters
> #30808: drivers/media/dvb-frontends/drx39xyj/drxj.c:5975:
> +	WR16(devAddr, VSB_TOP_SNRTH_RCA1__A, 0x0042);	/* drop thresholds by 1 dB */
> 
> WARNING: line over 80 characters
> #30809: drivers/media/dvb-frontends/drx39xyj/drxj.c:5976:
> +	WR16(devAddr, VSB_TOP_SNRTH_RCA2__A, 0x0053);	/* drop thresholds by 2 dB */
> 
> WARNING: Missing a blank line after declarations
> #30817: drivers/media/dvb-frontends/drx39xyj/drxj.c:5984:
> +		u16_t fecOcSncMode = 0;
> +		RR16(devAddr, FEC_OC_SNC_MODE__A, &fecOcSncMode);
> 
> WARNING: Missing a blank line after declarations
> #30831: drivers/media/dvb-frontends/drx39xyj/drxj.c:5998:
> +		u16_t fecOcRegMode = 0;
> +		RR16(devAddr, FEC_OC_MODE__A, &fecOcRegMode);
> 
> WARNING: line over 80 characters
> #30838: drivers/media/dvb-frontends/drx39xyj/drxj.c:6005:
> +	WR16(devAddr, FEC_DI_TIMEOUT_LO__A, 0);	/* timeout counter for restarting */
> 
> WARNING: line over 80 characters
> #30867: drivers/media/dvb-frontends/drx39xyj/drxj.c:6034:
> +		/* TODO fix this, store a DRXJCfgAfeGain_t structure in DRXJData_t instead
> 
> WARNING: line over 80 characters
> #30881: drivers/media/dvb-frontends/drx39xyj/drxj.c:6048:
> +		/* TODO: move to setStandard after hardware reset value problem is solved */
> 
> WARNING: Missing a blank line after declarations
> #30884: drivers/media/dvb-frontends/drx39xyj/drxj.c:6051:
> +		DRXCfgMPEGOutput_t cfgMPEGOutput;
> +		cfgMPEGOutput.enableMPEGOutput = TRUE;
> 
> ERROR: return is not a function, parentheses are not required
> #30931: drivers/media/dvb-frontends/drx39xyj/drxj.c:6098:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #30933: drivers/media/dvb-frontends/drx39xyj/drxj.c:6100:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #30962: drivers/media/dvb-frontends/drx39xyj/drxj.c:6129:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #30964: drivers/media/dvb-frontends/drx39xyj/drxj.c:6131:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #31000: drivers/media/dvb-frontends/drx39xyj/drxj.c:6167:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #31002: drivers/media/dvb-frontends/drx39xyj/drxj.c:6169:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #31019: drivers/media/dvb-frontends/drx39xyj/drxj.c:6186:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #31021: drivers/media/dvb-frontends/drx39xyj/drxj.c:6188:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #31049: drivers/media/dvb-frontends/drx39xyj/drxj.c:6216:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #31051: drivers/media/dvb-frontends/drx39xyj/drxj.c:6218:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #31067: drivers/media/dvb-frontends/drx39xyj/drxj.c:6234:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #31069: drivers/media/dvb-frontends/drx39xyj/drxj.c:6236:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #31115: drivers/media/dvb-frontends/drx39xyj/drxj.c:6282:
> +	if (re & 0x0200) {
> +		re |= 0xfc00;
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #31124: drivers/media/dvb-frontends/drx39xyj/drxj.c:6291:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #31126: drivers/media/dvb-frontends/drx39xyj/drxj.c:6293:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #31192: drivers/media/dvb-frontends/drx39xyj/drxj.c:6359:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #31194: drivers/media/dvb-frontends/drx39xyj/drxj.c:6361:
> +	return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #31220: drivers/media/dvb-frontends/drx39xyj/drxj.c:6387:
> +	pI2CDeviceAddr_t devAddr = NULL;	/* device address for I2C writes */
> 
> WARNING: line over 80 characters
> #31221: drivers/media/dvb-frontends/drx39xyj/drxj.c:6388:
> +	pDRXJData_t extAttr = NULL;	/* Global data container for DRXJ specif data */
> 
> WARNING: line over 80 characters
> #31227: drivers/media/dvb-frontends/drx39xyj/drxj.c:6394:
> +	u32_t fecOcSncFailPeriod = 0;	/* Value for corresponding I2C register */
> 
> WARNING: line over 80 characters
> #31230: drivers/media/dvb-frontends/drx39xyj/drxj.c:6397:
> +	u16_t fecVdPlen = 0;	/* no of trellis symbols: VD SER measur period */
> 
> ERROR: return is not a function, parentheses are not required
> #31256: drivers/media/dvb-frontends/drx39xyj/drxj.c:6423:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: line over 80 characters
> #31265: drivers/media/dvb-frontends/drx39xyj/drxj.c:6432:
> +	/* TODO: use constant instead of calculation and remove the fecRsPlen in extAttr */
> 
> ERROR: return is not a function, parentheses are not required
> #31275: drivers/media/dvb-frontends/drx39xyj/drxj.c:6442:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #31305: drivers/media/dvb-frontends/drx39xyj/drxj.c:6472:
> +			return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #31309: drivers/media/dvb-frontends/drx39xyj/drxj.c:6476:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: line over 80 characters
> #31323: drivers/media/dvb-frontends/drx39xyj/drxj.c:6490:
> +		/* qamvd_period = (int)ceil(FEC_BITS_DESIRED/                      */
> 
> WARNING: line over 80 characters
> #31324: drivers/media/dvb-frontends/drx39xyj/drxj.c:6491:
> +		/*                    (qamvd_prescale*plen*(qam_constellation+1))) */
> 
> WARNING: line over 80 characters
> #31325: drivers/media/dvb-frontends/drx39xyj/drxj.c:6492:
> +		/* vd_bit_cnt   = qamvd_period*qamvd_prescale*plen                 */
> 
> WARNING: line over 80 characters
> #31326: drivers/media/dvb-frontends/drx39xyj/drxj.c:6493:
> +		/*     result is within 32 bit arithmetic ->                       */
> 
> WARNING: line over 80 characters
> #31327: drivers/media/dvb-frontends/drx39xyj/drxj.c:6494:
> +		/*     no need for mult or frac functions                          */
> 
> WARNING: line over 80 characters
> #31332: drivers/media/dvb-frontends/drx39xyj/drxj.c:6499:
> +		qamVdBitCnt = qamVdPrescale * fecVdPlen;	/* temp storage */
> 
> WARNING: line over 80 characters
> #31336: drivers/media/dvb-frontends/drx39xyj/drxj.c:6503:
> +			/* a(16 bit) * b(4 bit) = 20 bit result => Mult32 not needed */
> 
> WARNING: line over 80 characters
> #31342: drivers/media/dvb-frontends/drx39xyj/drxj.c:6509:
> +			/* a(16 bit) * b(5 bit) = 21 bit result => Mult32 not needed */
> 
> ERROR: return is not a function, parentheses are not required
> #31348: drivers/media/dvb-frontends/drx39xyj/drxj.c:6515:
> +			return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #31366: drivers/media/dvb-frontends/drx39xyj/drxj.c:6533:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #31368: drivers/media/dvb-frontends/drx39xyj/drxj.c:6535:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #31446: drivers/media/dvb-frontends/drx39xyj/drxj.c:6613:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #31448: drivers/media/dvb-frontends/drx39xyj/drxj.c:6615:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #31526: drivers/media/dvb-frontends/drx39xyj/drxj.c:6693:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #31528: drivers/media/dvb-frontends/drx39xyj/drxj.c:6695:
> +	return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #31542: drivers/media/dvb-frontends/drx39xyj/drxj.c:6709:
> +	const u8_t qamDqQualFun[] = {	/* this is hw reset value. no necessary to re-write */
> 
> WARNING: Missing a blank line after declarations
> #31543: drivers/media/dvb-frontends/drx39xyj/drxj.c:6710:
> +	const u8_t qamDqQualFun[] = {	/* this is hw reset value. no necessary to re-write */
> +		DRXJ_16TO8(4),	/* fun0  */
> 
> ERROR: return is not a function, parentheses are not required
> #31606: drivers/media/dvb-frontends/drx39xyj/drxj.c:6773:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #31608: drivers/media/dvb-frontends/drx39xyj/drxj.c:6775:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #31686: drivers/media/dvb-frontends/drx39xyj/drxj.c:6853:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #31688: drivers/media/dvb-frontends/drx39xyj/drxj.c:6855:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #31766: drivers/media/dvb-frontends/drx39xyj/drxj.c:6933:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #31768: drivers/media/dvb-frontends/drx39xyj/drxj.c:6935:
> +	return (DRX_STS_ERROR);
> 
> WARNING: please, no spaces at the start of a line
> #31785: drivers/media/dvb-frontends/drx39xyj/drxj.c:6952:
> +       pDRXChannel_t channel, DRXFrequency_t tunerFreqOffset, u32_t op)$
> 
> ERROR: return is not a function, parentheses are not required
> #31945: drivers/media/dvb-frontends/drx39xyj/drxj.c:7112:
> +				return (DRX_STS_INVALID_ARG);
> 
> WARNING: line over 80 characters
> #31967: drivers/media/dvb-frontends/drx39xyj/drxj.c:7134:
> +			setEnvParameters = QAM_TOP_ANNEX_A;	/* annex             */
> 
> WARNING: line over 80 characters
> #31968: drivers/media/dvb-frontends/drx39xyj/drxj.c:7135:
> +			setParamParameters[0] = channel->constellation;	/* constellation     */
> 
> WARNING: line over 80 characters
> #31969: drivers/media/dvb-frontends/drx39xyj/drxj.c:7136:
> +			setParamParameters[1] = DRX_INTERLEAVEMODE_I12_J17;	/* interleave mode   */
> 
> WARNING: line over 80 characters
> #31971: drivers/media/dvb-frontends/drx39xyj/drxj.c:7138:
> +			setEnvParameters = QAM_TOP_ANNEX_B;	/* annex             */
> 
> WARNING: line over 80 characters
> #31972: drivers/media/dvb-frontends/drx39xyj/drxj.c:7139:
> +			setParamParameters[0] = channel->constellation;	/* constellation     */
> 
> WARNING: line over 80 characters
> #31973: drivers/media/dvb-frontends/drx39xyj/drxj.c:7140:
> +			setParamParameters[1] = channel->interleavemode;	/* interleave mode   */
> 
> WARNING: line over 80 characters
> #31975: drivers/media/dvb-frontends/drx39xyj/drxj.c:7142:
> +			setEnvParameters = QAM_TOP_ANNEX_C;	/* annex             */
> 
> WARNING: line over 80 characters
> #31976: drivers/media/dvb-frontends/drx39xyj/drxj.c:7143:
> +			setParamParameters[0] = channel->constellation;	/* constellation     */
> 
> WARNING: line over 80 characters
> #31977: drivers/media/dvb-frontends/drx39xyj/drxj.c:7144:
> +			setParamParameters[1] = DRX_INTERLEAVEMODE_I12_J17;	/* interleave mode   */
> 
> ERROR: return is not a function, parentheses are not required
> #31979: drivers/media/dvb-frontends/drx39xyj/drxj.c:7146:
> +			return (DRX_STS_INVALID_ARG);
> 
> WARNING: line over 80 characters
> #32011: drivers/media/dvb-frontends/drx39xyj/drxj.c:7178:
> +		   -set params (resets IQM,QAM,FEC HW; initializes some SCU variables )
> 
> WARNING: line over 80 characters
> #32034: drivers/media/dvb-frontends/drx39xyj/drxj.c:7201:
> +	/* STEP 3: enable the system in a mode where the ADC provides valid signal
> 
> WARNING: braces {} are not necessary for single statement blocks
> #32038: drivers/media/dvb-frontends/drx39xyj/drxj.c:7205:
> +	if ((op & QAM_SET_OP_ALL) || (op & QAM_SET_OP_SPECTRUM)) {
> +		CHK_ERROR(SetFrequency(demod, channel, tunerFreqOffset));
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #32049: drivers/media/dvb-frontends/drx39xyj/drxj.c:7216:
> +		if (extAttr->hasLNA == FALSE) {
> +			WR16(devAddr, IQM_AF_AMUX__A, 0x02);
> +		}
> 
> WARNING: line over 80 characters
> #32056: drivers/media/dvb-frontends/drx39xyj/drxj.c:7223:
> +		WR16(devAddr, SCU_RAM_QAM_WR_RSV_0__A, 0x5f);	/* scu temporary shut down agc */
> 
> WARNING: line over 80 characters
> #32067: drivers/media/dvb-frontends/drx39xyj/drxj.c:7234:
> +		WR16(devAddr, IQM_CF_SCALE_SH__A, IQM_CF_SCALE_SH__PRE);	/*! reset default val ! */
> 
> WARNING: line over 80 characters
> #32069: drivers/media/dvb-frontends/drx39xyj/drxj.c:7236:
> +		WR16(devAddr, QAM_SY_TIMEOUT__A, QAM_SY_TIMEOUT__PRE);	/*! reset default val ! */
> 
> WARNING: line over 80 characters
> #32071: drivers/media/dvb-frontends/drx39xyj/drxj.c:7238:
> +			WR16(devAddr, QAM_SY_SYNC_LWM__A, QAM_SY_SYNC_LWM__PRE);	/*! reset default val ! */
> 
> WARNING: line over 80 characters
> #32072: drivers/media/dvb-frontends/drx39xyj/drxj.c:7239:
> +			WR16(devAddr, QAM_SY_SYNC_AWM__A, QAM_SY_SYNC_AWM__PRE);	/*! reset default val ! */
> 
> WARNING: line over 80 characters
> #32073: drivers/media/dvb-frontends/drx39xyj/drxj.c:7240:
> +			WR16(devAddr, QAM_SY_SYNC_HWM__A, QAM_SY_SYNC_HWM__PRE);	/*! reset default val ! */
> 
> WARNING: line over 80 characters
> #32081: drivers/media/dvb-frontends/drx39xyj/drxj.c:7248:
> +				WR16(devAddr, QAM_SY_SYNC_HWM__A, QAM_SY_SYNC_HWM__PRE);	/*! reset default val ! */
> 
> ERROR: return is not a function, parentheses are not required
> #32090: drivers/media/dvb-frontends/drx39xyj/drxj.c:7257:
> +				return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #32094: drivers/media/dvb-frontends/drx39xyj/drxj.c:7261:
> +		WR16(devAddr, QAM_LC_MODE__A, QAM_LC_MODE__PRE);	/*! reset default val ! */
> 
> WARNING: line over 80 characters
> #32131: drivers/media/dvb-frontends/drx39xyj/drxj.c:7298:
> +			/* TODO fix this, store a DRXJCfgAfeGain_t structure in DRXJData_t instead
> 
> ERROR: return is not a function, parentheses are not required
> #32164: drivers/media/dvb-frontends/drx39xyj/drxj.c:7331:
> +				return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #32191: drivers/media/dvb-frontends/drx39xyj/drxj.c:7358:
> +			return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #32203: drivers/media/dvb-frontends/drx39xyj/drxj.c:7370:
> +			/* TODO: move to setStandard after hardware reset value problem is solved */
> 
> ERROR: return is not a function, parentheses are not required
> #32240: drivers/media/dvb-frontends/drx39xyj/drxj.c:7407:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #32242: drivers/media/dvb-frontends/drx39xyj/drxj.c:7409:
> +	return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #32264: drivers/media/dvb-frontends/drx39xyj/drxj.c:7431:
> +	/* Silence the controlling of lc, equ, and the acquisition state machine */
> 
> WARNING: braces {} are not necessary for single statement blocks
> #32320: drivers/media/dvb-frontends/drx39xyj/drxj.c:7487:
> +	while ((fsmState != 4) && (i++ < 100)) {
> +		RR16(devAddr, SCU_RAM_QAM_FSM_STATE__A, &fsmState);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #32325: drivers/media/dvb-frontends/drx39xyj/drxj.c:7492:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #32327: drivers/media/dvb-frontends/drx39xyj/drxj.c:7494:
> +	return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #32372: drivers/media/dvb-frontends/drx39xyj/drxj.c:7539:
> +					/* some delay to see if fec_lock possible TODO find the right value */
> 
> WARNING: line over 80 characters
> #32373: drivers/media/dvb-frontends/drx39xyj/drxj.c:7540:
> +					timeoutOfs += DRXJ_QAM_DEMOD_LOCK_EXT_WAITTIME;	/* see something, waiting longer */
> 
> WARNING: line over 80 characters
> #32379: drivers/media/dvb-frontends/drx39xyj/drxj.c:7546:
> +			if ((*lockStatus == DRXJ_DEMOD_LOCK) &&	/* still demod_lock in 150ms */
> 
> WARNING: line over 80 characters
> #32402: drivers/media/dvb-frontends/drx39xyj/drxj.c:7569:
> +					/* reset timer TODO: still need 500ms? */
> 
> WARNING: line over 80 characters
> #32415: drivers/media/dvb-frontends/drx39xyj/drxj.c:7582:
> +			if ((*lockStatus == DRXJ_DEMOD_LOCK) &&	/* still demod_lock in 150ms */
> 
> ERROR: return is not a function, parentheses are not required
> #32444: drivers/media/dvb-frontends/drx39xyj/drxj.c:7611:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #32446: drivers/media/dvb-frontends/drx39xyj/drxj.c:7613:
> +	return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #32484: drivers/media/dvb-frontends/drx39xyj/drxj.c:7651:
> +					timeoutOfs += DRXJ_QAM_DEMOD_LOCK_EXT_WAITTIME;	/* see something, wait longer */
> 
> WARNING: line over 80 characters
> #32497: drivers/media/dvb-frontends/drx39xyj/drxj.c:7664:
> +					/* reset timer TODO: still need 300ms? */
> 
> ERROR: return is not a function, parentheses are not required
> #32515: drivers/media/dvb-frontends/drx39xyj/drxj.c:7682:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #32517: drivers/media/dvb-frontends/drx39xyj/drxj.c:7684:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #32546: drivers/media/dvb-frontends/drx39xyj/drxj.c:7713:
> +		if (channel->mirror == DRX_MIRROR_AUTO) {
> [...]
> +		} else {
> [...]
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #32575: drivers/media/dvb-frontends/drx39xyj/drxj.c:7742:
> +			if (channel->mirror == DRX_MIRROR_AUTO) {
> [...]
> +			} else {
> [...]
> 
> WARNING: line over 80 characters
> #32588: drivers/media/dvb-frontends/drx39xyj/drxj.c:7755:
> +				/* QAM254 not locked -> try to lock QAM64 constellation */
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #32593: drivers/media/dvb-frontends/drx39xyj/drxj.c:7760:
> +				if (channel->mirror == DRX_MIRROR_AUTO) {
> [...]
> +				} else {
> [...]
> 
> WARNING: Missing a blank line after declarations
> #32600: drivers/media/dvb-frontends/drx39xyj/drxj.c:7767:
> +					u16_t qamCtlEna = 0;
> +					RR16(demod->myI2CDevAddr,
> 
> WARNING: line over 80 characters
> #32607: drivers/media/dvb-frontends/drx39xyj/drxj.c:7774:
> +					WR16(demod->myI2CDevAddr, SCU_RAM_QAM_FSM_STATE_TGT__A, 0x2);	/* force to rate hunting */
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #32626: drivers/media/dvb-frontends/drx39xyj/drxj.c:7793:
> +			if (channel->mirror == DRX_MIRROR_AUTO) {
> [...]
> +			} else {
> [...]
> 
> WARNING: Missing a blank line after declarations
> #32633: drivers/media/dvb-frontends/drx39xyj/drxj.c:7800:
> +				u16_t qamCtlEna = 0;
> +				RR16(demod->myI2CDevAddr,
> 
> WARNING: line over 80 characters
> #32638: drivers/media/dvb-frontends/drx39xyj/drxj.c:7805:
> +				WR16(demod->myI2CDevAddr, SCU_RAM_QAM_FSM_STATE_TGT__A, 0x2);	/* force to rate hunting */
> 
> ERROR: return is not a function, parentheses are not required
> #32652: drivers/media/dvb-frontends/drx39xyj/drxj.c:7819:
> +			return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #32656: drivers/media/dvb-frontends/drx39xyj/drxj.c:7823:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #32659: drivers/media/dvb-frontends/drx39xyj/drxj.c:7826:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #32664: drivers/media/dvb-frontends/drx39xyj/drxj.c:7831:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #32685: drivers/media/dvb-frontends/drx39xyj/drxj.c:7852:
> +	if (devAddr == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #32686: drivers/media/dvb-frontends/drx39xyj/drxj.c:7853:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #32712: drivers/media/dvb-frontends/drx39xyj/drxj.c:7879:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #32714: drivers/media/dvb-frontends/drx39xyj/drxj.c:7881:
> +	return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #32742: drivers/media/dvb-frontends/drx39xyj/drxj.c:7909:
> +	u16_t qamSlErrPower = 0;	/* accumulated error between raw and sliced symbols */
> 
> WARNING: line over 80 characters
> #32749: drivers/media/dvb-frontends/drx39xyj/drxj.c:7916:
> +	u32_t qamSlSigPower = 0;	/* used for MER, depends of QAM constellation */
> 
> ERROR: return is not a function, parentheses are not required
> #32802: drivers/media/dvb-frontends/drx39xyj/drxj.c:7969:
> +		return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #32860: drivers/media/dvb-frontends/drx39xyj/drxj.c:8027:
> +	if (m > (rsBitCnt >> (e + 1)) || (rsBitCnt >> e) == 0) {
> [...]
> +	} else {
> [...]
> 
> WARNING: line over 80 characters
> #32873: drivers/media/dvb-frontends/drx39xyj/drxj.c:8040:
> +	   => (20 bits * 12 bits) /(16 bits * 7 bits)  => safe in 32 bits computation
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #32886: drivers/media/dvb-frontends/drx39xyj/drxj.c:8053:
> +	if (extAttr->standard == DRX_STANDARD_ITU_B) {
> [...]
> +	} else {
> [...]
> 
> ERROR: return is not a function, parentheses are not required
> #32900: drivers/media/dvb-frontends/drx39xyj/drxj.c:8067:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #32902: drivers/media/dvb-frontends/drx39xyj/drxj.c:8069:
> +	return (DRX_STS_ERROR);
> 
> ERROR: space prohibited after that open parenthesis '('
> #32944: drivers/media/dvb-frontends/drx39xyj/drxj.c:8111:
> +	fecOcOcrMode = (	/* output select:  observe bus */
> 
> WARNING: braces {} are not necessary for single statement blocks
> #32970: drivers/media/dvb-frontends/drx39xyj/drxj.c:8137:
> +	if ((re & 0x0200) == 0x0200) {
> +		re |= 0xFC00;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #32973: drivers/media/dvb-frontends/drx39xyj/drxj.c:8140:
> +	if ((im & 0x0200) == 0x0200) {
> +		im |= 0xFC00;
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #32982: drivers/media/dvb-frontends/drx39xyj/drxj.c:8149:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #32984: drivers/media/dvb-frontends/drx39xyj/drxj.c:8151:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #33130: drivers/media/dvb-frontends/drx39xyj/drxj.c:8297:
> +		if (extAttr->phaseCorrectionBypass) {
> [...]
> +		} else {
> [...]
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #33181: drivers/media/dvb-frontends/drx39xyj/drxj.c:8348:
> +		if (extAttr->enableCVBSOutput) {
> [...]
> +		} else {
> [...]
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #33187: drivers/media/dvb-frontends/drx39xyj/drxj.c:8354:
> +		if (extAttr->enableSIFOutput) {
> [...]
> +		} else {
> [...]
> 
> ERROR: return is not a function, parentheses are not required
> #33197: drivers/media/dvb-frontends/drx39xyj/drxj.c:8364:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #33199: drivers/media/dvb-frontends/drx39xyj/drxj.c:8366:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #33217: drivers/media/dvb-frontends/drx39xyj/drxj.c:8384:
> +	if (outputCfg == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #33218: drivers/media/dvb-frontends/drx39xyj/drxj.c:8385:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #33253: drivers/media/dvb-frontends/drx39xyj/drxj.c:8420:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #33255: drivers/media/dvb-frontends/drx39xyj/drxj.c:8422:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #33277: drivers/media/dvb-frontends/drx39xyj/drxj.c:8444:
> +	if (!DRXJ_ISATVSTD(extAttr->standard)) {
> +		return DRX_STS_ERROR;
> +	}
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #33287: drivers/media/dvb-frontends/drx39xyj/drxj.c:8454:
> +	    (coef->coef0 < ((s16_t) ~ (ATV_TOP_EQU0_EQU_C0__M >> 1))) ||
>  	                            ^
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #33288: drivers/media/dvb-frontends/drx39xyj/drxj.c:8455:
> +	    (coef->coef1 < ((s16_t) ~ (ATV_TOP_EQU1_EQU_C1__M >> 1))) ||
>  	                            ^
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #33289: drivers/media/dvb-frontends/drx39xyj/drxj.c:8456:
> +	    (coef->coef2 < ((s16_t) ~ (ATV_TOP_EQU2_EQU_C2__M >> 1))) ||
>  	                            ^
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #33290: drivers/media/dvb-frontends/drx39xyj/drxj.c:8457:
> +	    (coef->coef3 < ((s16_t) ~ (ATV_TOP_EQU3_EQU_C3__M >> 1)))) {
>  	                            ^
> 
> ERROR: return is not a function, parentheses are not required
> #33291: drivers/media/dvb-frontends/drx39xyj/drxj.c:8458:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #33303: drivers/media/dvb-frontends/drx39xyj/drxj.c:8470:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #33305: drivers/media/dvb-frontends/drx39xyj/drxj.c:8472:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #33331: drivers/media/dvb-frontends/drx39xyj/drxj.c:8498:
> +	if (!DRXJ_ISATVSTD(extAttr->standard)) {
> +		return DRX_STS_ERROR;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #33336: drivers/media/dvb-frontends/drx39xyj/drxj.c:8503:
> +	if (coef == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #33346: drivers/media/dvb-frontends/drx39xyj/drxj.c:8513:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #33348: drivers/media/dvb-frontends/drx39xyj/drxj.c:8515:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #33370: drivers/media/dvb-frontends/drx39xyj/drxj.c:8537:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #33387: drivers/media/dvb-frontends/drx39xyj/drxj.c:8554:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #33389: drivers/media/dvb-frontends/drx39xyj/drxj.c:8556:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #33411: drivers/media/dvb-frontends/drx39xyj/drxj.c:8578:
> +	if (settings == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #33420: drivers/media/dvb-frontends/drx39xyj/drxj.c:8587:
> +	return (DRX_STS_OK);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #33440: drivers/media/dvb-frontends/drx39xyj/drxj.c:8607:
> +	if (outputCfg == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #33445: drivers/media/dvb-frontends/drx39xyj/drxj.c:8612:
> +	if (data & ATV_TOP_STDBY_CVBS_STDBY_A2_ACTIVE) {
> [...]
> +	} else {
> [...]
> 
> ERROR: return is not a function, parentheses are not required
> #33459: drivers/media/dvb-frontends/drx39xyj/drxj.c:8626:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #33461: drivers/media/dvb-frontends/drx39xyj/drxj.c:8628:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #33483: drivers/media/dvb-frontends/drx39xyj/drxj.c:8650:
> +	if (agcStatus == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #33500: drivers/media/dvb-frontends/drx39xyj/drxj.c:8667:
> +	if (tmp % 1000 >= 500) {
> +		(agcStatus->rfAgcGain)++;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #33514: drivers/media/dvb-frontends/drx39xyj/drxj.c:8681:
> +	if (tmp % 1000 >= 500) {
> +		(agcStatus->ifAgcGain)++;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #33529: drivers/media/dvb-frontends/drx39xyj/drxj.c:8696:
> +	if ((data & 1) != 0) {
> +		data++;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #33546: drivers/media/dvb-frontends/drx39xyj/drxj.c:8713:
> +	if ((data & 1) != 0) {
> +		data++;
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #33561: drivers/media/dvb-frontends/drx39xyj/drxj.c:8728:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #33563: drivers/media/dvb-frontends/drx39xyj/drxj.c:8730:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #33596: drivers/media/dvb-frontends/drx39xyj/drxj.c:8763:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #33598: drivers/media/dvb-frontends/drx39xyj/drxj.c:8765:
> +	return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #33642: drivers/media/dvb-frontends/drx39xyj/drxj.c:8809:
> +					 (~ATV_TOP_STDBY_CVBS_STDBY_A2_ACTIVE)));
> 
> ERROR: return is not a function, parentheses are not required
> #33657: drivers/media/dvb-frontends/drx39xyj/drxj.c:8824:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #33659: drivers/media/dvb-frontends/drx39xyj/drxj.c:8826:
> +	return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #33675: drivers/media/dvb-frontends/drx39xyj/drxj.c:8842:
> +#define SCU_RAM_ATV_ENABLE_IIR_WA__A 0x831F6D	/* TODO remove after done with reg import */
> 
> WARNING: line over 80 characters
> #34145: drivers/media/dvb-frontends/drx39xyj/drxj.c:9312:
> +		WR16(devAddr, ATV_TOP_CR_AMP_TH__A, 0x2);	/* TODO check with IS */
> 
> WARNING: line over 80 characters
> #34176: drivers/media/dvb-frontends/drx39xyj/drxj.c:9343:
> +		WR16(devAddr, ATV_TOP_CR_AMP_TH__A, 0x2);	/* TODO check with IS */
> 
> ERROR: return is not a function, parentheses are not required
> #34197: drivers/media/dvb-frontends/drx39xyj/drxj.c:9364:
> +		return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #34201: drivers/media/dvb-frontends/drx39xyj/drxj.c:9368:
> +	if (extAttr->hasLNA == FALSE) {
> +		WR16(devAddr, IQM_AF_AMUX__A, 0x01);
> +	}
> 
> WARNING: line over 80 characters
> #34253: drivers/media/dvb-frontends/drx39xyj/drxj.c:9420:
> +	/* Set SCU ATV substandard,assuming this doesn't require running ATV block */
> 
> WARNING: line over 80 characters
> #34262: drivers/media/dvb-frontends/drx39xyj/drxj.c:9429:
> +	/* turn the analog work around on/off (must after set_env b/c it is set in mc) */
> 
> ERROR: return is not a function, parentheses are not required
> #34270: drivers/media/dvb-frontends/drx39xyj/drxj.c:9437:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #34272: drivers/media/dvb-frontends/drx39xyj/drxj.c:9439:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #34313: drivers/media/dvb-frontends/drx39xyj/drxj.c:9480:
> +	if (channel->mirror == DRX_MIRROR_AUTO) {
> [...]
> +	} else {
> [...]
> 
> WARNING: line over 80 characters
> #34331: drivers/media/dvb-frontends/drx39xyj/drxj.c:9498:
> +/*   if ( (extAttr->standard == DRX_STANDARD_FM) && (extAttr->flagSetAUDdone == TRUE) )
> 
> ERROR: return is not a function, parentheses are not required
> #34336: drivers/media/dvb-frontends/drx39xyj/drxj.c:9503:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #34338: drivers/media/dvb-frontends/drx39xyj/drxj.c:9505:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #34415: drivers/media/dvb-frontends/drx39xyj/drxj.c:9582:
> +		return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #34420: drivers/media/dvb-frontends/drx39xyj/drxj.c:9587:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #34422: drivers/media/dvb-frontends/drx39xyj/drxj.c:9589:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #34493: drivers/media/dvb-frontends/drx39xyj/drxj.c:9660:
> +		return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #34537: drivers/media/dvb-frontends/drx39xyj/drxj.c:9704:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #34539: drivers/media/dvb-frontends/drx39xyj/drxj.c:9706:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #34590: drivers/media/dvb-frontends/drx39xyj/drxj.c:9757:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #34592: drivers/media/dvb-frontends/drx39xyj/drxj.c:9759:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #34625: drivers/media/dvb-frontends/drx39xyj/drxj.c:9792:
> +	if (setStandard == TRUE) {
> +		CHK_ERROR(AUDCtrlSetStandard(demod, &audStandard));
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #34676: drivers/media/dvb-frontends/drx39xyj/drxj.c:9843:
> +	if (modus == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #34726: drivers/media/dvb-frontends/drx39xyj/drxj.c:9893:
> +	if (status == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #34790: drivers/media/dvb-frontends/drx39xyj/drxj.c:9957:
> +	if (status == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #34868: drivers/media/dvb-frontends/drx39xyj/drxj.c:10035:
> +	if (status == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #34912: drivers/media/dvb-frontends/drx39xyj/drxj.c:10079:
> +	if (volume == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #34936: drivers/media/dvb-frontends/drx39xyj/drxj.c:10103:
> +		if (volume->volume < AUD_VOLUME_DB_MIN) {
> +			volume->volume = AUD_VOLUME_DB_MIN;
> +		}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #34939: drivers/media/dvb-frontends/drx39xyj/drxj.c:10106:
> +		if (volume->volume > AUD_VOLUME_DB_MAX) {
> +			volume->volume = AUD_VOLUME_DB_MAX;
> +		}
> 
> ERROR: that open brace { should be on the previous line
> #34947: drivers/media/dvb-frontends/drx39xyj/drxj.c:10114:
> +	if ((rAVC & AUD_DSP_WR_AVC_AVC_ON__M) == AUD_DSP_WR_AVC_AVC_ON_OFF)
> +	{
> 
> WARNING: line over 80 characters
> #35006: drivers/media/dvb-frontends/drx39xyj/drxj.c:10173:
> +	/* read qpeak registers and calculate strength of left and right carrier */
> 
> WARNING: braces {} are not necessary for single statement blocks
> #35044: drivers/media/dvb-frontends/drx39xyj/drxj.c:10211:
> +	if (volume == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #35067: drivers/media/dvb-frontends/drx39xyj/drxj.c:10234:
> +	wVolume &= (u16_t) ~ AUD_DSP_WR_VOLUME_VOL_MAIN__M;
>  	                   ^
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #35084: drivers/media/dvb-frontends/drx39xyj/drxj.c:10251:
> +	wAVC &= (u16_t) ~ AUD_DSP_WR_AVC_AVC_ON__M;
>  	                ^
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #35085: drivers/media/dvb-frontends/drx39xyj/drxj.c:10252:
> +	wAVC &= (u16_t) ~ AUD_DSP_WR_AVC_AVC_DECAY__M;
>  	                ^
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #35113: drivers/media/dvb-frontends/drx39xyj/drxj.c:10280:
> +	wAVC &= (u16_t) ~ AUD_DSP_WR_AVC_AVC_MAX_ATT__M;
>  	                ^
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #35129: drivers/media/dvb-frontends/drx39xyj/drxj.c:10296:
> +	wAVC &= (u16_t) ~ AUD_DSP_WR_AVC_AVC_MAX_GAIN__M;
>  	                ^
> 
> WARNING: braces {} are not necessary for single statement blocks
> #35145: drivers/media/dvb-frontends/drx39xyj/drxj.c:10312:
> +	if (volume->avcRefLevel > AUD_MAX_AVC_REF_LEVEL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #35149: drivers/media/dvb-frontends/drx39xyj/drxj.c:10316:
> +	wAVC &= (u16_t) ~ AUD_DSP_WR_AVC_AVC_REF_LEV__M;
>  	                ^
> 
> WARNING: braces {} are not necessary for single statement blocks
> #35179: drivers/media/dvb-frontends/drx39xyj/drxj.c:10346:
> +	if (output == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #35253: drivers/media/dvb-frontends/drx39xyj/drxj.c:10420:
> +		if (output->wordLength == DRX_I2S_WORDLENGTH_16) {
> +			output->frequency *= 2;
> +		}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #35285: drivers/media/dvb-frontends/drx39xyj/drxj.c:10452:
> +	if (output == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #35301: drivers/media/dvb-frontends/drx39xyj/drxj.c:10468:
> +	wI2SConfig &= (u16_t) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_SLV_MST__M;
>  	                      ^
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #35315: drivers/media/dvb-frontends/drx39xyj/drxj.c:10482:
> +	wI2SConfig &= (u16_t) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_WS_MODE__M;
>  	                      ^
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #35329: drivers/media/dvb-frontends/drx39xyj/drxj.c:10496:
> +	wI2SConfig &= (u16_t) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_WORD_LEN__M;
>  	                      ^
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #35343: drivers/media/dvb-frontends/drx39xyj/drxj.c:10510:
> +	wI2SConfig &= (u16_t) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_WS_POL__M;
>  	                      ^
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #35356: drivers/media/dvb-frontends/drx39xyj/drxj.c:10523:
> +	wI2SConfig &= (u16_t) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE__M;
>  	                      ^
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #35357: drivers/media/dvb-frontends/drx39xyj/drxj.c:10524:
> +	if (output->outputEnable == TRUE) {
> [...]
> +	} else {
> [...]
> 
> WARNING: braces {} are not necessary for single statement blocks
> #35379: drivers/media/dvb-frontends/drx39xyj/drxj.c:10546:
> +	if (output->wordLength == DRX_I2S_WORDLENGTH_16) {
> +		wI2SFreq *= 2;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #35437: drivers/media/dvb-frontends/drx39xyj/drxj.c:10604:
> +	if (autoSound == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: line over 80 characters
> #35454: drivers/media/dvb-frontends/drx39xyj/drxj.c:10621:
> +	case AUD_DEM_WR_MODUS_MOD_ASS_OFF | AUD_DEM_WR_MODUS_MOD_DIS_STD_CHG_DISABLED:
> 
> WARNING: line over 80 characters
> #35455: drivers/media/dvb-frontends/drx39xyj/drxj.c:10622:
> +	case AUD_DEM_WR_MODUS_MOD_ASS_OFF | AUD_DEM_WR_MODUS_MOD_DIS_STD_CHG_ENABLED:
> 
> WARNING: line over 80 characters
> #35459: drivers/media/dvb-frontends/drx39xyj/drxj.c:10626:
> +	case AUD_DEM_WR_MODUS_MOD_ASS_ON | AUD_DEM_WR_MODUS_MOD_DIS_STD_CHG_ENABLED:
> 
> WARNING: line over 80 characters
> #35463: drivers/media/dvb-frontends/drx39xyj/drxj.c:10630:
> +	case AUD_DEM_WR_MODUS_MOD_ASS_ON | AUD_DEM_WR_MODUS_MOD_DIS_STD_CHG_DISABLED:
> 
> WARNING: braces {} are not necessary for single statement blocks
> #35495: drivers/media/dvb-frontends/drx39xyj/drxj.c:10662:
> +	if (autoSound == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #35512: drivers/media/dvb-frontends/drx39xyj/drxj.c:10679:
> +	wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_ASS__M;
>  	                  ^
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #35513: drivers/media/dvb-frontends/drx39xyj/drxj.c:10680:
> +	wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_DIS_STD_CHG__M;
>  	                  ^
> 
> WARNING: braces {} are not necessary for single statement blocks
> #35532: drivers/media/dvb-frontends/drx39xyj/drxj.c:10699:
> +	if (wModus != rModus) {
> +		WR16(devAddr, AUD_DEM_WR_MODUS__A, wModus);
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #35561: drivers/media/dvb-frontends/drx39xyj/drxj.c:10728:
> +	if (thres == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #35601: drivers/media/dvb-frontends/drx39xyj/drxj.c:10768:
> +	if (thres == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #35656: drivers/media/dvb-frontends/drx39xyj/drxj.c:10823:
> +	if (carriers == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #35756: drivers/media/dvb-frontends/drx39xyj/drxj.c:10923:
> +	if (carriers == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #35772: drivers/media/dvb-frontends/drx39xyj/drxj.c:10939:
> +	wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_CM_A__M;
>  	                  ^
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #35787: drivers/media/dvb-frontends/drx39xyj/drxj.c:10954:
> +	wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_CM_B__M;
>  	                  ^
> 
> WARNING: braces {} are not necessary for single statement blocks
> #35801: drivers/media/dvb-frontends/drx39xyj/drxj.c:10968:
> +	if (wModus != rModus) {
> +		WR16(devAddr, AUD_DEM_WR_MODUS__A, wModus);
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #35848: drivers/media/dvb-frontends/drx39xyj/drxj.c:11015:
> +	if (mixer == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #35943: drivers/media/dvb-frontends/drx39xyj/drxj.c:11110:
> +	if (mixer == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #35958: drivers/media/dvb-frontends/drx39xyj/drxj.c:11125:
> +	srcI2SMatr &= (u16_t) ~ AUD_DSP_WR_SRC_I2S_MATR_SRC_I2S__M;
>  	                      ^
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #35978: drivers/media/dvb-frontends/drx39xyj/drxj.c:11145:
> +	srcI2SMatr &= (u16_t) ~ AUD_DSP_WR_SRC_I2S_MATR_MAT_I2S__M;
>  	                      ^
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #36000: drivers/media/dvb-frontends/drx39xyj/drxj.c:11167:
> +	fmMatr &= (u16_t) ~ AUD_DEM_WR_FM_MATRIX__M;
>  	                  ^
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36022: drivers/media/dvb-frontends/drx39xyj/drxj.c:11189:
> +	if (extAttr->audData.autoSound == DRX_AUD_AUTO_SOUND_OFF) {
> +		WR16(devAddr, AUD_DEM_WR_FM_MATRIX__A, fmMatr);
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36050: drivers/media/dvb-frontends/drx39xyj/drxj.c:11217:
> +	if (avSync == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #36066: drivers/media/dvb-frontends/drx39xyj/drxj.c:11233:
> +	wAudVidSync &= (u16_t) ~ AUD_DSP_WR_AV_SYNC_AV_ON__M;
>  	                       ^
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #36068: drivers/media/dvb-frontends/drx39xyj/drxj.c:11235:
> +	if (*avSync == DRX_AUD_AVSYNC_OFF) {
> [...]
> +	} else {
> [...]
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #36074: drivers/media/dvb-frontends/drx39xyj/drxj.c:11241:
> +	wAudVidSync &= (u16_t) ~ AUD_DSP_WR_AV_SYNC_AV_STD_SEL__M;
>  	                       ^
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36115: drivers/media/dvb-frontends/drx39xyj/drxj.c:11282:
> +	if (avSync == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36172: drivers/media/dvb-frontends/drx39xyj/drxj.c:11339:
> +	if (dev == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36214: drivers/media/dvb-frontends/drx39xyj/drxj.c:11381:
> +	if (dev == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #36225: drivers/media/dvb-frontends/drx39xyj/drxj.c:11392:
> +	wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_HDEV_A__M;
>  	                  ^
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36239: drivers/media/dvb-frontends/drx39xyj/drxj.c:11406:
> +	if (wModus != rModus) {
> +		WR16(devAddr, AUD_DEM_WR_MODUS__A, wModus);
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36267: drivers/media/dvb-frontends/drx39xyj/drxj.c:11434:
> +	if (presc == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36342: drivers/media/dvb-frontends/drx39xyj/drxj.c:11509:
> +	if (presc == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36387: drivers/media/dvb-frontends/drx39xyj/drxj.c:11554:
> +		if (nicamPrescaler > 127) {
> +			nicamPrescaler = 127;
> +		}
> 
> ERROR: return is not a function, parentheses are not required
> #36394: drivers/media/dvb-frontends/drx39xyj/drxj.c:11561:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36425: drivers/media/dvb-frontends/drx39xyj/drxj.c:11592:
> +	if (beep == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36438: drivers/media/dvb-frontends/drx39xyj/drxj.c:11605:
> +	if ((beep->volume > 0) || (beep->volume < -127)) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36442: drivers/media/dvb-frontends/drx39xyj/drxj.c:11609:
> +	if (beep->frequency > 3000) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36450: drivers/media/dvb-frontends/drx39xyj/drxj.c:11617:
> +	if (frequency > AUD_DSP_WR_BEEPER_BEEP_FREQUENCY__M) {
> +		frequency = AUD_DSP_WR_BEEPER_BEEP_FREQUENCY__M;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36455: drivers/media/dvb-frontends/drx39xyj/drxj.c:11622:
> +	if (beep->mute == TRUE) {
> +		theBeep = 0;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36489: drivers/media/dvb-frontends/drx39xyj/drxj.c:11656:
> +	if (standard == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36533: drivers/media/dvb-frontends/drx39xyj/drxj.c:11700:
> +		if (extAttr->audData.btscDetect == DRX_BTSC_MONO_AND_SAP) {
> +			wStandard = AUD_DEM_WR_STANDARD_SEL_STD_SEL_BTSC_SAP;
> +		}
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #36581: drivers/media/dvb-frontends/drx39xyj/drxj.c:11748:
> +		wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_6_5MHZ__M;
>  		                  ^
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #36590: drivers/media/dvb-frontends/drx39xyj/drxj.c:11757:
> +		wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_4_5MHZ__M;
>  		                  ^
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #36601: drivers/media/dvb-frontends/drx39xyj/drxj.c:11768:
> +	wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_FMRADIO__M;
>  	                  ^
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #36604: drivers/media/dvb-frontends/drx39xyj/drxj.c:11771:
> +	if (extAttr->audData.deemph == DRX_AUD_FM_DEEMPH_50US) {
> [...]
> +	} else {
> [...]
> 
> ERROR: space prohibited after that '~' (ctx:WxW)
> #36610: drivers/media/dvb-frontends/drx39xyj/drxj.c:11777:
> +	wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_BTSC__M;
>  	                  ^
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36618: drivers/media/dvb-frontends/drx39xyj/drxj.c:11785:
> +	if (wModus != rModus) {
> +		WR16(devAddr, AUD_DEM_WR_MODUS__A, wModus);
> +	}
> 
> WARNING: line over 80 characters
> #36626: drivers/media/dvb-frontends/drx39xyj/drxj.c:11793:
> +	/* detection, need to keep things very minimal here, but keep audio       */
> 
> WARNING: line over 80 characters
> #36627: drivers/media/dvb-frontends/drx39xyj/drxj.c:11794:
> +	/* buffers intact                                                         */
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36660: drivers/media/dvb-frontends/drx39xyj/drxj.c:11827:
> +	if (standard == NULL) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: line over 80 characters
> #36678: drivers/media/dvb-frontends/drx39xyj/drxj.c:11845:
> +	if (rData >= AUD_DEM_RD_STANDARD_RES_STD_RESULT_DETECTION_STILL_ACTIVE) {
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #36768: drivers/media/dvb-frontends/drx39xyj/drxj.c:11935:
> +	if ((status.carrierA == TRUE) || (status.carrierB == TRUE)) {
> [...]
> +	} else {
> [...]
> 
> ERROR: return is not a function, parentheses are not required
> #36774: drivers/media/dvb-frontends/drx39xyj/drxj.c:11941:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #36777: drivers/media/dvb-frontends/drx39xyj/drxj.c:11944:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #36797: drivers/media/dvb-frontends/drx39xyj/drxj.c:11964:
> +	if (lockStatus == DRX_LOCKED) {
> [...]
> +	} else {
> [...]
> 
> ERROR: return is not a function, parentheses are not required
> #36803: drivers/media/dvb-frontends/drx39xyj/drxj.c:11970:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #36806: drivers/media/dvb-frontends/drx39xyj/drxj.c:11973:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #36859: drivers/media/dvb-frontends/drx39xyj/drxj.c:12026:
> +		if (OOBLockState & 0x0008) {
> [...]
> +		} else if ((OOBLockState & 0x0002) && (OOBLockState & 0x0001)) {
> [...]
> 
> WARNING: line over 80 characters
> #36865: drivers/media/dvb-frontends/drx39xyj/drxj.c:12032:
> +		/* 0xC0 NEVER LOCKED (system will never be able to lock to the signal) */
> 
> ERROR: return is not a function, parentheses are not required
> #36871: drivers/media/dvb-frontends/drx39xyj/drxj.c:12038:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #36873: drivers/media/dvb-frontends/drx39xyj/drxj.c:12040:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #36926: drivers/media/dvb-frontends/drx39xyj/drxj.c:12093:
> +		return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #36952: drivers/media/dvb-frontends/drx39xyj/drxj.c:12119:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #36954: drivers/media/dvb-frontends/drx39xyj/drxj.c:12121:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #36985: drivers/media/dvb-frontends/drx39xyj/drxj.c:12152:
> +	if ((demod == NULL) || (freqOffset == NULL)) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: line over 80 characters
> #37010: drivers/media/dvb-frontends/drx39xyj/drxj.c:12177:
> +	coarseFreqOffset = coarseSign * Frac(tempFreqOffset, 1000, FRAC_ROUND);	/* KHz */
> 
> ERROR: return is not a function, parentheses are not required
> #37029: drivers/media/dvb-frontends/drx39xyj/drxj.c:12196:
> +		return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #37035: drivers/media/dvb-frontends/drx39xyj/drxj.c:12202:
> +	/* at least 5 MSB are 0 so first divide with 2^5 without information loss */
> 
> WARNING: line over 80 characters
> #37046: drivers/media/dvb-frontends/drx39xyj/drxj.c:12213:
> +	fineFreqOffset = fineSign * Frac(fineFreqOffset, 1000, FRAC_ROUND);	/* KHz */
> 
> ERROR: return is not a function, parentheses are not required
> #37053: drivers/media/dvb-frontends/drx39xyj/drxj.c:12220:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #37055: drivers/media/dvb-frontends/drx39xyj/drxj.c:12222:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #37088: drivers/media/dvb-frontends/drx39xyj/drxj.c:12255:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #37090: drivers/media/dvb-frontends/drx39xyj/drxj.c:12257:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #37231: drivers/media/dvb-frontends/drx39xyj/drxj.c:12398:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #37233: drivers/media/dvb-frontends/drx39xyj/drxj.c:12400:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #37278: drivers/media/dvb-frontends/drx39xyj/drxj.c:12445:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #37280: drivers/media/dvb-frontends/drx39xyj/drxj.c:12447:
> +	return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
> 
> ERROR: space required after that ',' (ctx:VxO)
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
>                                         ^
> 
> ERROR: space required before that '-' (ctx:OxV)
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
>                                          ^
> 
> ERROR: space required after that ',' (ctx:VxO)
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
>                                            ^
> 
> ERROR: space required before that '-' (ctx:OxV)
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
>                                             ^
> 
> ERROR: space required after that ',' (ctx:VxV)
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
>                                                  ^
> 
> ERROR: space required after that ',' (ctx:VxO)
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
>                                                        ^
> 
> ERROR: space required before that '-' (ctx:OxV)
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
>                                                         ^
> 
> ERROR: space required after that ',' (ctx:VxO)
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
>                                                           ^
> 
> ERROR: space required before that '-' (ctx:OxV)
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
>                                                            ^
> 
> ERROR: space required after that ',' (ctx:VxO)
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
>                                                               ^
> 
> ERROR: space required before that '-' (ctx:OxV)
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
>                                                                ^
> 
> ERROR: space required after that ',' (ctx:VxO)
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
>                                                                   ^
> 
> ERROR: space required before that '-' (ctx:OxV)
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
>                                                                    ^
> 
> ERROR: space required after that ',' (ctx:VxV)
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
>                                                                       ^
> 
> ERROR: space required after that ',' (ctx:VxV)
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
>                                                                          ^
> 
> ERROR: space required after that ',' (ctx:VxV)
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
>                                                                             ^
> 
> ERROR: space required after that ',' (ctx:VxV)
> #37300: drivers/media/dvb-frontends/drx39xyj/drxj.c:12467:
> +#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
>                                                                                 ^
> 
> WARNING: line over 80 characters
> #37301: drivers/media/dvb-frontends/drx39xyj/drxj.c:12468:
> +#define IMPULSE_COSINE_ALPHA_0_5    { 2, 0,-2,-2, 2, 5, 2,-10,-20,-14,20,74,125,145}	/*sqrt raised-cosine filter with alpha=0.5 */
> 
> ERROR: space required after that ',' (ctx:VxO)
> #37301: drivers/media/dvb-frontends/drx39xyj/drxj.c:12468:
> +#define IMPULSE_COSINE_ALPHA_0_5    { 2, 0,-2,-2, 2, 5, 2,-10,-20,-14,20,74,125,145}	/*sqrt raised-cosine filter with alpha=0.5 */
>                                            ^
> 
> ERROR: space required before that '-' (ctx:OxV)
> #37301: drivers/media/dvb-frontends/drx39xyj/drxj.c:12468:
> +#define IMPULSE_COSINE_ALPHA_0_5    { 2, 0,-2,-2, 2, 5, 2,-10,-20,-14,20,74,125,145}	/*sqrt raised-cosine filter with alpha=0.5 */
>                                             ^
> 
> ERROR: space required after that ',' (ctx:VxO)
> #37301: drivers/media/dvb-frontends/drx39xyj/drxj.c:12468:
> +#define IMPULSE_COSINE_ALPHA_0_5    { 2, 0,-2,-2, 2, 5, 2,-10,-20,-14,20,74,125,145}	/*sqrt raised-cosine filter with alpha=0.5 */
>                                               ^
> 
> ERROR: space required before that '-' (ctx:OxV)
> #37301: drivers/media/dvb-frontends/drx39xyj/drxj.c:12468:
> +#define IMPULSE_COSINE_ALPHA_0_5    { 2, 0,-2,-2, 2, 5, 2,-10,-20,-14,20,74,125,145}	/*sqrt raised-cosine filter with alpha=0.5 */
>                                                ^
> 
> ERROR: space required after that ',' (ctx:VxO)
> #37301: drivers/media/dvb-frontends/drx39xyj/drxj.c:12468:
> +#define IMPULSE_COSINE_ALPHA_0_5    { 2, 0,-2,-2, 2, 5, 2,-10,-20,-14,20,74,125,145}	/*sqrt raised-cosine filter with alpha=0.5 */
>                                                           ^
> 
> ERROR: space required before that '-' (ctx:OxV)
> #37301: drivers/media/dvb-frontends/drx39xyj/drxj.c:12468:
> +#define IMPULSE_COSINE_ALPHA_0_5    { 2, 0,-2,-2, 2, 5, 2,-10,-20,-14,20,74,125,145}	/*sqrt raised-cosine filter with alpha=0.5 */
>                                                            ^
> 
> ERROR: space required after that ',' (ctx:VxO)
> #37301: drivers/media/dvb-frontends/drx39xyj/drxj.c:12468:
> +#define IMPULSE_COSINE_ALPHA_0_5    { 2, 0,-2,-2, 2, 5, 2,-10,-20,-14,20,74,125,145}	/*sqrt raised-cosine filter with alpha=0.5 */
>                                                               ^
> 
> ERROR: space required before that '-' (ctx:OxV)
> #37301: drivers/media/dvb-frontends/drx39xyj/drxj.c:12468:
> +#define IMPULSE_COSINE_ALPHA_0_5    { 2, 0,-2,-2, 2, 5, 2,-10,-20,-14,20,74,125,145}	/*sqrt raised-cosine filter with alpha=0.5 */
>                                                                ^
> 
> ERROR: space required after that ',' (ctx:VxO)
> #37301: drivers/media/dvb-frontends/drx39xyj/drxj.c:12468:
> +#define IMPULSE_COSINE_ALPHA_0_5    { 2, 0,-2,-2, 2, 5, 2,-10,-20,-14,20,74,125,145}	/*sqrt raised-cosine filter with alpha=0.5 */
>                                                                   ^
> 
> ERROR: space required before that '-' (ctx:OxV)
> #37301: drivers/media/dvb-frontends/drx39xyj/drxj.c:12468:
> +#define IMPULSE_COSINE_ALPHA_0_5    { 2, 0,-2,-2, 2, 5, 2,-10,-20,-14,20,74,125,145}	/*sqrt raised-cosine filter with alpha=0.5 */
>                                                                    ^
> 
> ERROR: space required after that ',' (ctx:VxV)
> #37301: drivers/media/dvb-frontends/drx39xyj/drxj.c:12468:
> +#define IMPULSE_COSINE_ALPHA_0_5    { 2, 0,-2,-2, 2, 5, 2,-10,-20,-14,20,74,125,145}	/*sqrt raised-cosine filter with alpha=0.5 */
>                                                                       ^
> 
> ERROR: space required after that ',' (ctx:VxV)
> #37301: drivers/media/dvb-frontends/drx39xyj/drxj.c:12468:
> +#define IMPULSE_COSINE_ALPHA_0_5    { 2, 0,-2,-2, 2, 5, 2,-10,-20,-14,20,74,125,145}	/*sqrt raised-cosine filter with alpha=0.5 */
>                                                                          ^
> 
> ERROR: space required after that ',' (ctx:VxV)
> #37301: drivers/media/dvb-frontends/drx39xyj/drxj.c:12468:
> +#define IMPULSE_COSINE_ALPHA_0_5    { 2, 0,-2,-2, 2, 5, 2,-10,-20,-14,20,74,125,145}	/*sqrt raised-cosine filter with alpha=0.5 */
>                                                                             ^
> 
> ERROR: space required after that ',' (ctx:VxV)
> #37301: drivers/media/dvb-frontends/drx39xyj/drxj.c:12468:
> +#define IMPULSE_COSINE_ALPHA_0_5    { 2, 0,-2,-2, 2, 5, 2,-10,-20,-14,20,74,125,145}	/*sqrt raised-cosine filter with alpha=0.5 */
>                                                                                 ^
> 
> WARNING: line over 80 characters
> #37302: drivers/media/dvb-frontends/drx39xyj/drxj.c:12469:
> +#define IMPULSE_COSINE_ALPHA_RO_0_5 { 0, 0, 1, 2, 3, 0,-7,-15,-16,  0,34,77,114,128}	/*full raised-cosine filter with alpha=0.5 (receiver only) */
> 
> ERROR: space required after that ',' (ctx:VxO)
> #37302: drivers/media/dvb-frontends/drx39xyj/drxj.c:12469:
> +#define IMPULSE_COSINE_ALPHA_RO_0_5 { 0, 0, 1, 2, 3, 0,-7,-15,-16,  0,34,77,114,128}	/*full raised-cosine filter with alpha=0.5 (receiver only) */
>                                                        ^
> 
> ERROR: space required before that '-' (ctx:OxV)
> #37302: drivers/media/dvb-frontends/drx39xyj/drxj.c:12469:
> +#define IMPULSE_COSINE_ALPHA_RO_0_5 { 0, 0, 1, 2, 3, 0,-7,-15,-16,  0,34,77,114,128}	/*full raised-cosine filter with alpha=0.5 (receiver only) */
>                                                         ^
> 
> ERROR: space required after that ',' (ctx:VxO)
> #37302: drivers/media/dvb-frontends/drx39xyj/drxj.c:12469:
> +#define IMPULSE_COSINE_ALPHA_RO_0_5 { 0, 0, 1, 2, 3, 0,-7,-15,-16,  0,34,77,114,128}	/*full raised-cosine filter with alpha=0.5 (receiver only) */
>                                                           ^
> 
> ERROR: space required before that '-' (ctx:OxV)
> #37302: drivers/media/dvb-frontends/drx39xyj/drxj.c:12469:
> +#define IMPULSE_COSINE_ALPHA_RO_0_5 { 0, 0, 1, 2, 3, 0,-7,-15,-16,  0,34,77,114,128}	/*full raised-cosine filter with alpha=0.5 (receiver only) */
>                                                            ^
> 
> ERROR: space required after that ',' (ctx:VxO)
> #37302: drivers/media/dvb-frontends/drx39xyj/drxj.c:12469:
> +#define IMPULSE_COSINE_ALPHA_RO_0_5 { 0, 0, 1, 2, 3, 0,-7,-15,-16,  0,34,77,114,128}	/*full raised-cosine filter with alpha=0.5 (receiver only) */
>                                                               ^
> 
> ERROR: space required before that '-' (ctx:OxV)
> #37302: drivers/media/dvb-frontends/drx39xyj/drxj.c:12469:
> +#define IMPULSE_COSINE_ALPHA_RO_0_5 { 0, 0, 1, 2, 3, 0,-7,-15,-16,  0,34,77,114,128}	/*full raised-cosine filter with alpha=0.5 (receiver only) */
>                                                                ^
> 
> ERROR: space required after that ',' (ctx:VxV)
> #37302: drivers/media/dvb-frontends/drx39xyj/drxj.c:12469:
> +#define IMPULSE_COSINE_ALPHA_RO_0_5 { 0, 0, 1, 2, 3, 0,-7,-15,-16,  0,34,77,114,128}	/*full raised-cosine filter with alpha=0.5 (receiver only) */
>                                                                       ^
> 
> ERROR: space required after that ',' (ctx:VxV)
> #37302: drivers/media/dvb-frontends/drx39xyj/drxj.c:12469:
> +#define IMPULSE_COSINE_ALPHA_RO_0_5 { 0, 0, 1, 2, 3, 0,-7,-15,-16,  0,34,77,114,128}	/*full raised-cosine filter with alpha=0.5 (receiver only) */
>                                                                          ^
> 
> ERROR: space required after that ',' (ctx:VxV)
> #37302: drivers/media/dvb-frontends/drx39xyj/drxj.c:12469:
> +#define IMPULSE_COSINE_ALPHA_RO_0_5 { 0, 0, 1, 2, 3, 0,-7,-15,-16,  0,34,77,114,128}	/*full raised-cosine filter with alpha=0.5 (receiver only) */
>                                                                             ^
> 
> ERROR: space required after that ',' (ctx:VxV)
> #37302: drivers/media/dvb-frontends/drx39xyj/drxj.c:12469:
> +#define IMPULSE_COSINE_ALPHA_RO_0_5 { 0, 0, 1, 2, 3, 0,-7,-15,-16,  0,34,77,114,128}	/*full raised-cosine filter with alpha=0.5 (receiver only) */
>                                                                                 ^
> 
> WARNING: line over 80 characters
> #37328: drivers/media/dvb-frontends/drx39xyj/drxj.c:12495:
> +		{DRXJ_16TO8(-92), DRXJ_16TO8(-108), DRXJ_16TO8(100)},	/* TARGET_MODE = 0:     PFI_A = -23/32; PFI_B = -54/32;  PFI_C = 25/32; fg = 0.5 MHz (Att=26dB) */
> 
> WARNING: line over 80 characters
> #37329: drivers/media/dvb-frontends/drx39xyj/drxj.c:12496:
> +		{DRXJ_16TO8(-64), DRXJ_16TO8(-80), DRXJ_16TO8(80)},	/* TARGET_MODE = 1:     PFI_A = -16/32; PFI_B = -40/32;  PFI_C = 20/32; fg = 1.0 MHz (Att=28dB) */
> 
> WARNING: line over 80 characters
> #37330: drivers/media/dvb-frontends/drx39xyj/drxj.c:12497:
> +		{DRXJ_16TO8(-80), DRXJ_16TO8(-98), DRXJ_16TO8(92)},	/* TARGET_MODE = 2, 3:  PFI_A = -20/32; PFI_B = -49/32;  PFI_C = 23/32; fg = 0.8 MHz (Att=25dB) */
> 
> WARNING: line over 80 characters
> #37331: drivers/media/dvb-frontends/drx39xyj/drxj.c:12498:
> +		{DRXJ_16TO8(-80), DRXJ_16TO8(-98), DRXJ_16TO8(92)}	/* TARGET_MODE = 2, 3:  PFI_A = -20/32; PFI_B = -49/32;  PFI_C = 23/32; fg = 0.8 MHz (Att=25dB) */
> 
> ERROR: return is not a function, parentheses are not required
> #37352: drivers/media/dvb-frontends/drx39xyj/drxj.c:12519:
> +		return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #37359: drivers/media/dvb-frontends/drx39xyj/drxj.c:12526:
> +		return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #37468: drivers/media/dvb-frontends/drx39xyj/drxj.c:12635:
> +	WR16(devAddr, SIO_TOP_COMM_KEY__A, 0xFABA);	/*  Write magic word to enable pdr reg write  */
> 
> WARNING: line over 80 characters
> #37475: drivers/media/dvb-frontends/drx39xyj/drxj.c:12642:
> +	WR16(devAddr, SIO_TOP_COMM_KEY__A, 0x0000);	/*  Write magic word to disable pdr reg write */
> 
> ERROR: return is not a function, parentheses are not required
> #37569: drivers/media/dvb-frontends/drx39xyj/drxj.c:12736:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #37572: drivers/media/dvb-frontends/drx39xyj/drxj.c:12739:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #37594: drivers/media/dvb-frontends/drx39xyj/drxj.c:12761:
> +	if (oobStatus == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #37595: drivers/media/dvb-frontends/drx39xyj/drxj.c:12762:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #37599: drivers/media/dvb-frontends/drx39xyj/drxj.c:12766:
> +		return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #37613: drivers/media/dvb-frontends/drx39xyj/drxj.c:12780:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #37616: drivers/media/dvb-frontends/drx39xyj/drxj.c:12783:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #37632: drivers/media/dvb-frontends/drx39xyj/drxj.c:12799:
> +	if (cfgData == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #37633: drivers/media/dvb-frontends/drx39xyj/drxj.c:12800:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #37640: drivers/media/dvb-frontends/drx39xyj/drxj.c:12807:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #37642: drivers/media/dvb-frontends/drx39xyj/drxj.c:12809:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #37658: drivers/media/dvb-frontends/drx39xyj/drxj.c:12825:
> +	if (cfgData == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #37659: drivers/media/dvb-frontends/drx39xyj/drxj.c:12826:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #37665: drivers/media/dvb-frontends/drx39xyj/drxj.c:12832:
> +	return (DRX_STS_OK);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #37682: drivers/media/dvb-frontends/drx39xyj/drxj.c:12849:
> +	if (cfgData == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #37683: drivers/media/dvb-frontends/drx39xyj/drxj.c:12850:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #37690: drivers/media/dvb-frontends/drx39xyj/drxj.c:12857:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #37692: drivers/media/dvb-frontends/drx39xyj/drxj.c:12859:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #37708: drivers/media/dvb-frontends/drx39xyj/drxj.c:12875:
> +	if (cfgData == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #37709: drivers/media/dvb-frontends/drx39xyj/drxj.c:12876:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #37715: drivers/media/dvb-frontends/drx39xyj/drxj.c:12882:
> +	return (DRX_STS_OK);
> 
> WARNING: line over 80 characters
> #37727: drivers/media/dvb-frontends/drx39xyj/drxj.c:12894:
> +  ===== CtrlSetChannel() ==========================================================
> 
> WARNING: braces {} are not necessary for single statement blocks
> #37761: drivers/media/dvb-frontends/drx39xyj/drxj.c:12928:
> +	if ((demod == NULL) || (channel == NULL)) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #37779: drivers/media/dvb-frontends/drx39xyj/drxj.c:12946:
> +	case DRX_STANDARD_NTSC:
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #37780: drivers/media/dvb-frontends/drx39xyj/drxj.c:12947:
> +	case DRX_STANDARD_FM:
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #37781: drivers/media/dvb-frontends/drx39xyj/drxj.c:12948:
> +	case DRX_STANDARD_PAL_SECAM_BG:
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #37782: drivers/media/dvb-frontends/drx39xyj/drxj.c:12949:
> +	case DRX_STANDARD_PAL_SECAM_DK:
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #37783: drivers/media/dvb-frontends/drx39xyj/drxj.c:12950:
> +	case DRX_STANDARD_PAL_SECAM_I:
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #37784: drivers/media/dvb-frontends/drx39xyj/drxj.c:12951:
> +	case DRX_STANDARD_PAL_SECAM_L:
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #37785: drivers/media/dvb-frontends/drx39xyj/drxj.c:12952:
> +	case DRX_STANDARD_PAL_SECAM_LP:
> 
> ERROR: return is not a function, parentheses are not required
> #37790: drivers/media/dvb-frontends/drx39xyj/drxj.c:12957:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #37805: drivers/media/dvb-frontends/drx39xyj/drxj.c:12972:
> +			return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #37818: drivers/media/dvb-frontends/drx39xyj/drxj.c:12985:
> +			return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #37835: drivers/media/dvb-frontends/drx39xyj/drxj.c:13002:
> +			return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #37858: drivers/media/dvb-frontends/drx39xyj/drxj.c:13025:
> +			return (DRX_STS_INVALID_ARG);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #37870: drivers/media/dvb-frontends/drx39xyj/drxj.c:13037:
> +			if ((bandwidthTemp % 100) >= 50) {
> +				bandwidth++;
> +			}
> 
> ERROR: return is not a function, parentheses are not required
> #37884: drivers/media/dvb-frontends/drx39xyj/drxj.c:13051:
> +			return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #37898: drivers/media/dvb-frontends/drx39xyj/drxj.c:13065:
> +			return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #37923: drivers/media/dvb-frontends/drx39xyj/drxj.c:13090:
> +			return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #37943: drivers/media/dvb-frontends/drx39xyj/drxj.c:13110:
> +			return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #37985: drivers/media/dvb-frontends/drx39xyj/drxj.c:13152:
> +			return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #38036: drivers/media/dvb-frontends/drx39xyj/drxj.c:13203:
> +		/* no tuner instance defined, use fixed intermediate frequency */
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #38044: drivers/media/dvb-frontends/drx39xyj/drxj.c:13211:
> +		if (channel->mirror == DRX_MIRROR_AUTO) {
> [...]
> +		} else {
> [...]
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #38060: drivers/media/dvb-frontends/drx39xyj/drxj.c:13227:
> +		if (channel->mirror == DRX_MIRROR_AUTO) {
> [...]
> +		} else {
> [...]
> 
> ERROR: return is not a function, parentheses are not required
> #38078: drivers/media/dvb-frontends/drx39xyj/drxj.c:13245:
> +		return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #38107: drivers/media/dvb-frontends/drx39xyj/drxj.c:13274:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #38109: drivers/media/dvb-frontends/drx39xyj/drxj.c:13276:
> +	return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #38113: drivers/media/dvb-frontends/drx39xyj/drxj.c:13280:
> +  ===== CtrlGetChannel() ==========================================================
> 
> WARNING: braces {} are not necessary for single statement blocks
> #38140: drivers/media/dvb-frontends/drx39xyj/drxj.c:13307:
> +	if ((demod == NULL) || (channel == NULL)) {
> +		return DRX_STS_INVALID_ARG;
> +	}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #38185: drivers/media/dvb-frontends/drx39xyj/drxj.c:13352:
> +		if (standard == DRX_STANDARD_FM) {
> +			channel->frequency -= DRXJ_FM_CARRIER_FREQ_OFFSET;
> +		}
> 
> WARNING: line over 80 characters
> #38225: drivers/media/dvb-frontends/drx39xyj/drxj.c:13392:
> +					u32_t rollOff = 113;	/* default annex C */
> 
> WARNING: braces {} are not necessary for single statement blocks
> #38227: drivers/media/dvb-frontends/drx39xyj/drxj.c:13394:
> +					if (standard == DRX_STANDARD_ITU_A) {
> +						rollOff = 115;
> +					}
> 
> WARNING: braces {} are not necessary for single statement blocks
> #38235: drivers/media/dvb-frontends/drx39xyj/drxj.c:13402:
> +					if ((bandwidthTemp % 100) >= 50) {
> +						bandwidth++;
> +					}
> 
> WARNING: line over 80 characters
> #38250: drivers/media/dvb-frontends/drx39xyj/drxj.c:13417:
> +				}	/* if (standard == DRX_STANDARD_ITU_B) */
> 
> ERROR: that open brace { should be on the previous line
> #38254: drivers/media/dvb-frontends/drx39xyj/drxj.c:13421:
> +					DRXJSCUCmd_t cmdSCU =
> +					    { /* command      */ 0,
> 
> ERROR: return is not a function, parentheses are not required
> #38300: drivers/media/dvb-frontends/drx39xyj/drxj.c:13467:
> +					return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #38318: drivers/media/dvb-frontends/drx39xyj/drxj.c:13485:
> +			return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #38321: drivers/media/dvb-frontends/drx39xyj/drxj.c:13488:
> +		if (lockStatus == DRX_LOCKED) {
> +			channel->mirror = extAttr->mirror;
> +		}
> 
> ERROR: return is not a function, parentheses are not required
> #38326: drivers/media/dvb-frontends/drx39xyj/drxj.c:13493:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #38328: drivers/media/dvb-frontends/drx39xyj/drxj.c:13495:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #38385: drivers/media/dvb-frontends/drx39xyj/drxj.c:13552:
> +	if ((sigQuality == NULL) || (demod == NULL)) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #38386: drivers/media/dvb-frontends/drx39xyj/drxj.c:13553:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #38448: drivers/media/dvb-frontends/drx39xyj/drxj.c:13615:
> +				return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #38468: drivers/media/dvb-frontends/drx39xyj/drxj.c:13635:
> +			return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #38489: drivers/media/dvb-frontends/drx39xyj/drxj.c:13656:
> +		return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #38492: drivers/media/dvb-frontends/drx39xyj/drxj.c:13659:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #38494: drivers/media/dvb-frontends/drx39xyj/drxj.c:13661:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #38523: drivers/media/dvb-frontends/drx39xyj/drxj.c:13690:
> +	if ((demod == NULL) || (lockStat == NULL)) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #38524: drivers/media/dvb-frontends/drx39xyj/drxj.c:13691:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #38563: drivers/media/dvb-frontends/drx39xyj/drxj.c:13730:
> +		return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #38577: drivers/media/dvb-frontends/drx39xyj/drxj.c:13744:
> +	} else if (cmdSCU.result[1] < SCU_RAM_PARAM_1_RES_DEMOD_GET_LOCK_LOCKED) {
> 
> ERROR: return is not a function, parentheses are not required
> #38589: drivers/media/dvb-frontends/drx39xyj/drxj.c:13756:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #38591: drivers/media/dvb-frontends/drx39xyj/drxj.c:13758:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #38611: drivers/media/dvb-frontends/drx39xyj/drxj.c:13778:
> +	if ((demod == NULL) || (complexNr == NULL)) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #38612: drivers/media/dvb-frontends/drx39xyj/drxj.c:13779:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #38632: drivers/media/dvb-frontends/drx39xyj/drxj.c:13799:
> +		return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #38635: drivers/media/dvb-frontends/drx39xyj/drxj.c:13802:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #38637: drivers/media/dvb-frontends/drx39xyj/drxj.c:13804:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #38659: drivers/media/dvb-frontends/drx39xyj/drxj.c:13826:
> +	if ((standard == NULL) || (demod == NULL)) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #38660: drivers/media/dvb-frontends/drx39xyj/drxj.c:13827:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #38696: drivers/media/dvb-frontends/drx39xyj/drxj.c:13863:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #38730: drivers/media/dvb-frontends/drx39xyj/drxj.c:13897:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #38734: drivers/media/dvb-frontends/drx39xyj/drxj.c:13901:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #38738: drivers/media/dvb-frontends/drx39xyj/drxj.c:13905:
> +	return (DRX_STS_ERROR);
> 
> WARNING: Missing a blank line after declarations
> #38756: drivers/media/dvb-frontends/drx39xyj/drxj.c:13923:
> +	pDRXJData_t extAttr = NULL;
> +	extAttr = (pDRXJData_t) demod->myExtAttr;
> 
> WARNING: braces {} are not necessary for single statement blocks
> #38759: drivers/media/dvb-frontends/drx39xyj/drxj.c:13926:
> +	if (standard == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #38760: drivers/media/dvb-frontends/drx39xyj/drxj.c:13927:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #38765: drivers/media/dvb-frontends/drx39xyj/drxj.c:13932:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #38767: drivers/media/dvb-frontends/drx39xyj/drxj.c:13934:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #38787: drivers/media/dvb-frontends/drx39xyj/drxj.c:13954:
> +	if (rateOffset == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #38788: drivers/media/dvb-frontends/drx39xyj/drxj.c:13955:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #38807: drivers/media/dvb-frontends/drx39xyj/drxj.c:13974:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #38810: drivers/media/dvb-frontends/drx39xyj/drxj.c:13977:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #38812: drivers/media/dvb-frontends/drx39xyj/drxj.c:13979:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #38842: drivers/media/dvb-frontends/drx39xyj/drxj.c:14009:
> +	if (mode == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #38843: drivers/media/dvb-frontends/drx39xyj/drxj.c:14010:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #38847: drivers/media/dvb-frontends/drx39xyj/drxj.c:14014:
> +	if (commonAttr->currentPowerMode == *mode) {
> +		return (DRX_STS_OK);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #38848: drivers/media/dvb-frontends/drx39xyj/drxj.c:14015:
> +		return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #38867: drivers/media/dvb-frontends/drx39xyj/drxj.c:14034:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: Unnecessary parentheses
> #38872: drivers/media/dvb-frontends/drx39xyj/drxj.c:14039:
> +	if ((commonAttr->currentPowerMode != DRX_POWER_UP)) {
> 
> WARNING: braces {} are not necessary for single statement blocks
> #38872: drivers/media/dvb-frontends/drx39xyj/drxj.c:14039:
> +	if ((commonAttr->currentPowerMode != DRX_POWER_UP)) {
> +		CHK_ERROR(PowerUpDevice(demod));
> +	}
> 
> WARNING: Unnecessary parentheses - maybe == should be = ?
> #38876: drivers/media/dvb-frontends/drx39xyj/drxj.c:14043:
> +	if ((*mode == DRX_POWER_UP)) {
> 
> WARNING: line over 80 characters
> #38881: drivers/media/dvb-frontends/drx39xyj/drxj.c:14048:
> +		/* Set pins with possible pull-ups connected to them in input mode */
> 
> ERROR: return is not a function, parentheses are not required
> #38913: drivers/media/dvb-frontends/drx39xyj/drxj.c:14080:
> +			return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #38920: drivers/media/dvb-frontends/drx39xyj/drxj.c:14087:
> +			/* Initialize HI, wakeup key especially before put IC to sleep */
> 
> ERROR: return is not a function, parentheses are not required
> #38930: drivers/media/dvb-frontends/drx39xyj/drxj.c:14097:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #38932: drivers/media/dvb-frontends/drx39xyj/drxj.c:14099:
> +	return (DRX_STS_ERROR);
> 
> ERROR: "foo * bar" should be "foo *bar"
> #38958: drivers/media/dvb-frontends/drx39xyj/drxj.c:14125:
> +CtrlVersion(pDRXDemodInstance_t demod, pDRXVersionList_t * versionList)
> 
> WARNING: static char array declaration should probably be static const char
> #38975: drivers/media/dvb-frontends/drx39xyj/drxj.c:14142:
> +	static char ucodeName[] = "Microcode";
> 
> WARNING: static char array declaration should probably be static const char
> #38976: drivers/media/dvb-frontends/drx39xyj/drxj.c:14143:
> +	static char deviceName[] = "Device";
> 
> WARNING: line over 80 characters
> #38993: drivers/media/dvb-frontends/drx39xyj/drxj.c:14160:
> +		/* TODO: The most significant Ma and Pa will be ignored, check with spec */
> 
> WARNING: line over 80 characters
> #39005: drivers/media/dvb-frontends/drx39xyj/drxj.c:14172:
> +		/* No microcode uploaded, No Rom existed, set version to 0.0.0 */
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #39064: drivers/media/dvb-frontends/drx39xyj/drxj.c:14231:
> +	if (mfx == 0x03) {
> [...]
> +	} else {
> [...]
> 
> WARNING: braces {} are not necessary for any arm of this statement
> #39075: drivers/media/dvb-frontends/drx39xyj/drxj.c:14242:
> +	if (mfx == 0x03) {
> [...]
> +	} else {
> [...]
> 
> ERROR: return is not a function, parentheses are not required
> #39086: drivers/media/dvb-frontends/drx39xyj/drxj.c:14253:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #39090: drivers/media/dvb-frontends/drx39xyj/drxj.c:14257:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #39167: drivers/media/dvb-frontends/drx39xyj/drxj.c:14334:
> +	return (retStatus);
> 
> ERROR: return is not a function, parentheses are not required
> #39171: drivers/media/dvb-frontends/drx39xyj/drxj.c:14338:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #39187: drivers/media/dvb-frontends/drx39xyj/drxj.c:14354:
> +	if ((addr == AUD_XFP_PRAM_4K__A) || (addr == AUD_XDFP_PRAM_4K__A)) {
> +		return (TRUE);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #39188: drivers/media/dvb-frontends/drx39xyj/drxj.c:14355:
> +		return (TRUE);
> 
> ERROR: return is not a function, parentheses are not required
> #39190: drivers/media/dvb-frontends/drx39xyj/drxj.c:14357:
> +	return (FALSE);
> 
> WARNING: line over 80 characters
> #39271: drivers/media/dvb-frontends/drx39xyj/drxj.c:14438:
> +		/* Check which part of MC need to be uploaded - Audio or not Audio */
> 
> WARNING: line over 80 characters
> #39274: drivers/media/dvb-frontends/drx39xyj/drxj.c:14441:
> +	    /*===================================================================*/
> 
> ERROR: return is not a function, parentheses are not required
> #39285: drivers/media/dvb-frontends/drx39xyj/drxj.c:14452:
> +						return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #39290: drivers/media/dvb-frontends/drx39xyj/drxj.c:14457:
> +	    /*===================================================================*/
> 
> WARNING: Too many leading tabs - consider code refactoring
> #39306: drivers/media/dvb-frontends/drx39xyj/drxj.c:14473:
> +						if (bytesLeftToCompare >
> 
> WARNING: line over 80 characters
> #39311: drivers/media/dvb-frontends/drx39xyj/drxj.c:14478:
> +							     DRXJ_UCODE_MAX_BUF_SIZE);
> 
> WARNING: Too many leading tabs - consider code refactoring
> #39312: drivers/media/dvb-frontends/drx39xyj/drxj.c:14479:
> +						} else {
> 
> WARNING: Too many leading tabs - consider code refactoring
> #39317: drivers/media/dvb-frontends/drx39xyj/drxj.c:14484:
> +						if (demod->myAccessFunct->
> 
> WARNING: line over 80 characters
> #39321: drivers/media/dvb-frontends/drx39xyj/drxj.c:14488:
> +								  bytesToCompare,
> 
> ERROR: return is not a function, parentheses are not required
> #39326: drivers/media/dvb-frontends/drx39xyj/drxj.c:14493:
> +							return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #39331: drivers/media/dvb-frontends/drx39xyj/drxj.c:14498:
> +								      mcDataBuffer,
> 
> WARNING: line over 80 characters
> #39332: drivers/media/dvb-frontends/drx39xyj/drxj.c:14499:
> +								      bytesToCompare);
> 
> WARNING: Too many leading tabs - consider code refactoring
> #39334: drivers/media/dvb-frontends/drx39xyj/drxj.c:14501:
> +						if (result != 0) {
> 
> ERROR: return is not a function, parentheses are not required
> #39335: drivers/media/dvb-frontends/drx39xyj/drxj.c:14502:
> +							return (DRX_STS_ERROR);
> 
> WARNING: line over 80 characters
> #39345: drivers/media/dvb-frontends/drx39xyj/drxj.c:14512:
> +					}	/* while( bytesToCompare > DRXJ_UCODE_MAX_BUF_SIZE ) */
> 
> WARNING: line over 80 characters
> #39349: drivers/media/dvb-frontends/drx39xyj/drxj.c:14516:
> +	    /*===================================================================*/
> 
> WARNING: braces {} are not necessary for single statement blocks
> #39362: drivers/media/dvb-frontends/drx39xyj/drxj.c:14529:
> +	if (uploadAudioMC == FALSE) {
> +		extAttr->flagAudMcUploaded = FALSE;
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #39366: drivers/media/dvb-frontends/drx39xyj/drxj.c:14533:
> +	return (DRX_STS_OK);
> 
> WARNING: line over 80 characters
> #39374: drivers/media/dvb-frontends/drx39xyj/drxj.c:14541:
> +/*===== SigStrength() =========================================================*/
> 
> WARNING: braces {} are not necessary for single statement blocks
> #39393: drivers/media/dvb-frontends/drx39xyj/drxj.c:14560:
> +	if ((sigStrength == NULL) || (demod == NULL)) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #39394: drivers/media/dvb-frontends/drx39xyj/drxj.c:14561:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #39424: drivers/media/dvb-frontends/drx39xyj/drxj.c:14591:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: line over 80 characters
> #39428: drivers/media/dvb-frontends/drx39xyj/drxj.c:14595:
> +	/* find out if signal strength is calculated in the same way for all standards */
> 
> ERROR: return is not a function, parentheses are not required
> #39429: drivers/media/dvb-frontends/drx39xyj/drxj.c:14596:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #39431: drivers/media/dvb-frontends/drx39xyj/drxj.c:14598:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #39454: drivers/media/dvb-frontends/drx39xyj/drxj.c:14621:
> +	if (misc == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #39455: drivers/media/dvb-frontends/drx39xyj/drxj.c:14622:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: line over 80 characters
> #39460: drivers/media/dvb-frontends/drx39xyj/drxj.c:14627:
> +	/* check if the same registers are used for all standards (QAM/VSB/ATV) */
> 
> ERROR: return is not a function, parentheses are not required
> #39482: drivers/media/dvb-frontends/drx39xyj/drxj.c:14649:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #39484: drivers/media/dvb-frontends/drx39xyj/drxj.c:14651:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #39501: drivers/media/dvb-frontends/drx39xyj/drxj.c:14668:
> +	if (misc == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #39502: drivers/media/dvb-frontends/drx39xyj/drxj.c:14669:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #39508: drivers/media/dvb-frontends/drx39xyj/drxj.c:14675:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #39510: drivers/media/dvb-frontends/drx39xyj/drxj.c:14677:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #39530: drivers/media/dvb-frontends/drx39xyj/drxj.c:14697:
> +	if (agcSettings == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #39531: drivers/media/dvb-frontends/drx39xyj/drxj.c:14698:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #39540: drivers/media/dvb-frontends/drx39xyj/drxj.c:14707:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39552: drivers/media/dvb-frontends/drx39xyj/drxj.c:14719:
> +	case DRX_STANDARD_PAL_SECAM_BG:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39553: drivers/media/dvb-frontends/drx39xyj/drxj.c:14720:
> +	case DRX_STANDARD_PAL_SECAM_DK:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39554: drivers/media/dvb-frontends/drx39xyj/drxj.c:14721:
> +	case DRX_STANDARD_PAL_SECAM_I:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39555: drivers/media/dvb-frontends/drx39xyj/drxj.c:14722:
> +	case DRX_STANDARD_PAL_SECAM_L:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39556: drivers/media/dvb-frontends/drx39xyj/drxj.c:14723:
> +	case DRX_STANDARD_PAL_SECAM_LP:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39557: drivers/media/dvb-frontends/drx39xyj/drxj.c:14724:
> +	case DRX_STANDARD_NTSC:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39558: drivers/media/dvb-frontends/drx39xyj/drxj.c:14725:
> +	case DRX_STANDARD_FM:
> 
> ERROR: return is not a function, parentheses are not required
> #39563: drivers/media/dvb-frontends/drx39xyj/drxj.c:14730:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #39566: drivers/media/dvb-frontends/drx39xyj/drxj.c:14733:
> +	return (DRX_STS_OK);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #39586: drivers/media/dvb-frontends/drx39xyj/drxj.c:14753:
> +	if (agcSettings == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #39587: drivers/media/dvb-frontends/drx39xyj/drxj.c:14754:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39599: drivers/media/dvb-frontends/drx39xyj/drxj.c:14766:
> +	case DRX_STANDARD_PAL_SECAM_BG:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39600: drivers/media/dvb-frontends/drx39xyj/drxj.c:14767:
> +	case DRX_STANDARD_PAL_SECAM_DK:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39601: drivers/media/dvb-frontends/drx39xyj/drxj.c:14768:
> +	case DRX_STANDARD_PAL_SECAM_I:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39602: drivers/media/dvb-frontends/drx39xyj/drxj.c:14769:
> +	case DRX_STANDARD_PAL_SECAM_L:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39603: drivers/media/dvb-frontends/drx39xyj/drxj.c:14770:
> +	case DRX_STANDARD_PAL_SECAM_LP:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39604: drivers/media/dvb-frontends/drx39xyj/drxj.c:14771:
> +	case DRX_STANDARD_NTSC:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39605: drivers/media/dvb-frontends/drx39xyj/drxj.c:14772:
> +	case DRX_STANDARD_FM:
> 
> ERROR: return is not a function, parentheses are not required
> #39610: drivers/media/dvb-frontends/drx39xyj/drxj.c:14777:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #39613: drivers/media/dvb-frontends/drx39xyj/drxj.c:14780:
> +	return (DRX_STS_OK);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #39633: drivers/media/dvb-frontends/drx39xyj/drxj.c:14800:
> +	if (agcSettings == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #39634: drivers/media/dvb-frontends/drx39xyj/drxj.c:14801:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #39643: drivers/media/dvb-frontends/drx39xyj/drxj.c:14810:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39655: drivers/media/dvb-frontends/drx39xyj/drxj.c:14822:
> +	case DRX_STANDARD_PAL_SECAM_BG:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39656: drivers/media/dvb-frontends/drx39xyj/drxj.c:14823:
> +	case DRX_STANDARD_PAL_SECAM_DK:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39657: drivers/media/dvb-frontends/drx39xyj/drxj.c:14824:
> +	case DRX_STANDARD_PAL_SECAM_I:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39658: drivers/media/dvb-frontends/drx39xyj/drxj.c:14825:
> +	case DRX_STANDARD_PAL_SECAM_L:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39659: drivers/media/dvb-frontends/drx39xyj/drxj.c:14826:
> +	case DRX_STANDARD_PAL_SECAM_LP:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39660: drivers/media/dvb-frontends/drx39xyj/drxj.c:14827:
> +	case DRX_STANDARD_NTSC:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39661: drivers/media/dvb-frontends/drx39xyj/drxj.c:14828:
> +	case DRX_STANDARD_FM:
> 
> ERROR: return is not a function, parentheses are not required
> #39666: drivers/media/dvb-frontends/drx39xyj/drxj.c:14833:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #39669: drivers/media/dvb-frontends/drx39xyj/drxj.c:14836:
> +	return (DRX_STS_OK);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #39689: drivers/media/dvb-frontends/drx39xyj/drxj.c:14856:
> +	if (agcSettings == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #39690: drivers/media/dvb-frontends/drx39xyj/drxj.c:14857:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39702: drivers/media/dvb-frontends/drx39xyj/drxj.c:14869:
> +	case DRX_STANDARD_PAL_SECAM_BG:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39703: drivers/media/dvb-frontends/drx39xyj/drxj.c:14870:
> +	case DRX_STANDARD_PAL_SECAM_DK:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39704: drivers/media/dvb-frontends/drx39xyj/drxj.c:14871:
> +	case DRX_STANDARD_PAL_SECAM_I:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39705: drivers/media/dvb-frontends/drx39xyj/drxj.c:14872:
> +	case DRX_STANDARD_PAL_SECAM_L:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39706: drivers/media/dvb-frontends/drx39xyj/drxj.c:14873:
> +	case DRX_STANDARD_PAL_SECAM_LP:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39707: drivers/media/dvb-frontends/drx39xyj/drxj.c:14874:
> +	case DRX_STANDARD_NTSC:	/* fallthrough */
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #39708: drivers/media/dvb-frontends/drx39xyj/drxj.c:14875:
> +	case DRX_STANDARD_FM:
> 
> ERROR: return is not a function, parentheses are not required
> #39713: drivers/media/dvb-frontends/drx39xyj/drxj.c:14880:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #39716: drivers/media/dvb-frontends/drx39xyj/drxj.c:14883:
> +	return (DRX_STS_OK);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #39744: drivers/media/dvb-frontends/drx39xyj/drxj.c:14911:
> +	if (agcInternal == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #39745: drivers/media/dvb-frontends/drx39xyj/drxj.c:14912:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #39776: drivers/media/dvb-frontends/drx39xyj/drxj.c:14943:
> +			return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #39781: drivers/media/dvb-frontends/drx39xyj/drxj.c:14948:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #39797: drivers/media/dvb-frontends/drx39xyj/drxj.c:14964:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #39799: drivers/media/dvb-frontends/drx39xyj/drxj.c:14966:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #39827: drivers/media/dvb-frontends/drx39xyj/drxj.c:14994:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #39863: drivers/media/dvb-frontends/drx39xyj/drxj.c:15030:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #39866: drivers/media/dvb-frontends/drx39xyj/drxj.c:15033:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #39868: drivers/media/dvb-frontends/drx39xyj/drxj.c:15035:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #39892: drivers/media/dvb-frontends/drx39xyj/drxj.c:15059:
> +	if (afeGain == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #39893: drivers/media/dvb-frontends/drx39xyj/drxj.c:15060:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #39909: drivers/media/dvb-frontends/drx39xyj/drxj.c:15076:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #39939: drivers/media/dvb-frontends/drx39xyj/drxj.c:15106:
> +		return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #39942: drivers/media/dvb-frontends/drx39xyj/drxj.c:15109:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #39944: drivers/media/dvb-frontends/drx39xyj/drxj.c:15111:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #39967: drivers/media/dvb-frontends/drx39xyj/drxj.c:15134:
> +	if (preSaw == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #39968: drivers/media/dvb-frontends/drx39xyj/drxj.c:15135:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #40001: drivers/media/dvb-frontends/drx39xyj/drxj.c:15168:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #40004: drivers/media/dvb-frontends/drx39xyj/drxj.c:15171:
> +	return (DRX_STS_OK);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #40027: drivers/media/dvb-frontends/drx39xyj/drxj.c:15194:
> +	if (afeGain == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #40028: drivers/media/dvb-frontends/drx39xyj/drxj.c:15195:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #40046: drivers/media/dvb-frontends/drx39xyj/drxj.c:15213:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #40049: drivers/media/dvb-frontends/drx39xyj/drxj.c:15216:
> +	return (DRX_STS_OK);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #40069: drivers/media/dvb-frontends/drx39xyj/drxj.c:15236:
> +	if (fecMeasSeqCount == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #40070: drivers/media/dvb-frontends/drx39xyj/drxj.c:15237:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #40075: drivers/media/dvb-frontends/drx39xyj/drxj.c:15242:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #40077: drivers/media/dvb-frontends/drx39xyj/drxj.c:15244:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #40096: drivers/media/dvb-frontends/drx39xyj/drxj.c:15263:
> +	if (accumCrRsCWErr == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #40097: drivers/media/dvb-frontends/drx39xyj/drxj.c:15264:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #40103: drivers/media/dvb-frontends/drx39xyj/drxj.c:15270:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #40105: drivers/media/dvb-frontends/drx39xyj/drxj.c:15272:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #40118: drivers/media/dvb-frontends/drx39xyj/drxj.c:15285:
> +	if (config == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #40119: drivers/media/dvb-frontends/drx39xyj/drxj.c:15286:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #40165: drivers/media/dvb-frontends/drx39xyj/drxj.c:15332:
> +	case DRXJ_CFG_MPEG_OUTPUT_MISC:
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #40170: drivers/media/dvb-frontends/drx39xyj/drxj.c:15337:
> +	case DRX_CFG_AUD_VOLUME:
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #40205: drivers/media/dvb-frontends/drx39xyj/drxj.c:15372:
> +	default:
> 
> ERROR: return is not a function, parentheses are not required
> #40206: drivers/media/dvb-frontends/drx39xyj/drxj.c:15373:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #40209: drivers/media/dvb-frontends/drx39xyj/drxj.c:15376:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #40211: drivers/media/dvb-frontends/drx39xyj/drxj.c:15378:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #40226: drivers/media/dvb-frontends/drx39xyj/drxj.c:15393:
> +	if (config == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #40227: drivers/media/dvb-frontends/drx39xyj/drxj.c:15394:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #40287: drivers/media/dvb-frontends/drx39xyj/drxj.c:15454:
> +	case DRXJ_CFG_MPEG_OUTPUT_MISC:
> 
> WARNING: Possible switch case/default not preceeded by break or fallthrough comment
> #40336: drivers/media/dvb-frontends/drx39xyj/drxj.c:15503:
> +	default:
> 
> ERROR: return is not a function, parentheses are not required
> #40337: drivers/media/dvb-frontends/drx39xyj/drxj.c:15504:
> +		return (DRX_STS_INVALID_ARG);
> 
> ERROR: return is not a function, parentheses are not required
> #40340: drivers/media/dvb-frontends/drx39xyj/drxj.c:15507:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #40342: drivers/media/dvb-frontends/drx39xyj/drxj.c:15509:
> +	return (DRX_STS_ERROR);
> 
> WARNING: braces {} are not necessary for single statement blocks
> #40367: drivers/media/dvb-frontends/drx39xyj/drxj.c:15534:
> +	if (demod->myExtAttr == NULL) {
> +		return (DRX_STS_INVALID_ARG);
> +	}
> 
> ERROR: return is not a function, parentheses are not required
> #40368: drivers/media/dvb-frontends/drx39xyj/drxj.c:15535:
> +		return (DRX_STS_INVALID_ARG);
> 
> WARNING: line over 80 characters
> #40387: drivers/media/dvb-frontends/drx39xyj/drxj.c:15554:
> +	/* TODO first make sure that everything keeps working before enabling this */
> 
> WARNING: Missing a blank line after declarations
> #40441: drivers/media/dvb-frontends/drx39xyj/drxj.c:15608:
> +			Bool_t bridgeClosed = TRUE;
> +			CHK_ERROR(CtrlI2CBridge(demod, &bridgeClosed));
> 
> WARNING: Missing a blank line after declarations
> #40448: drivers/media/dvb-frontends/drx39xyj/drxj.c:15615:
> +			Bool_t bridgeClosed = FALSE;
> +			CHK_ERROR(CtrlI2CBridge(demod, &bridgeClosed));
> 
> WARNING: line over 80 characters
> #40490: drivers/media/dvb-frontends/drx39xyj/drxj.c:15657:
> +	/* TODO: remove minOutputLevel and maxOutputLevel for both QAM and VSB after */
> 
> WARNING: line over 80 characters
> #40536: drivers/media/dvb-frontends/drx39xyj/drxj.c:15703:
> +	   Done to enable field application engineers to retreive drxdriver version
> 
> ERROR: return is not a function, parentheses are not required
> #40561: drivers/media/dvb-frontends/drx39xyj/drxj.c:15728:
> +	return (DRX_STS_OK);
> 
> ERROR: return is not a function, parentheses are not required
> #40564: drivers/media/dvb-frontends/drx39xyj/drxj.c:15731:
> +	return (DRX_STS_ERROR);
> 
> WARNING: Missing a blank line after declarations
> #40592: drivers/media/dvb-frontends/drx39xyj/drxj.c:15759:
> +			Bool_t bridgeClosed = TRUE;
> +			CHK_ERROR(CtrlI2CBridge(demod, &bridgeClosed));
> 
> WARNING: Missing a blank line after declarations
> #40597: drivers/media/dvb-frontends/drx39xyj/drxj.c:15764:
> +			Bool_t bridgeClosed = FALSE;
> +			CHK_ERROR(CtrlI2CBridge(demod, &bridgeClosed));
> 
> ERROR: return is not a function, parentheses are not required
> #40607: drivers/media/dvb-frontends/drx39xyj/drxj.c:15774:
> +	return (DRX_STS_ERROR);
> 
> ERROR: return is not a function, parentheses are not required
> #40802: drivers/media/dvb-frontends/drx39xyj/drxj.c:15969:
> +		return (DRX_STS_FUNC_NOT_AVAILABLE);
> 
> ERROR: return is not a function, parentheses are not required
> #40804: drivers/media/dvb-frontends/drx39xyj/drxj.c:15971:
> +	return (DRX_STS_OK);
> 
> WARNING: line over 80 characters
> #40818: drivers/media/dvb-frontends/drx39xyj/drxj.h:58:
> +	*;			/* Generate a fatal compiler error to make sure it stops here,
> 
> WARNING: line over 80 characters
> #40819: drivers/media/dvb-frontends/drx39xyj/drxj.h:59:
> +				   this is necesarry because not all compilers stop after a #error. */
> 
> WARNING: do not add new typedefs
> #40835: drivers/media/dvb-frontends/drx39xyj/drxj.h:77:
> +	typedef struct {
> 
> WARNING: line over 80 characters
> #40856: drivers/media/dvb-frontends/drx39xyj/drxj.h:100:
> +#define DRXJ_OOB_AGC_LOCK     (DRX_LOCK_STATE_1)	/* analog gain control lock */
> 
> WARNING: line over 80 characters
> #40857: drivers/media/dvb-frontends/drx39xyj/drxj.h:101:
> +#define DRXJ_OOB_SYNC_LOCK    (DRX_LOCK_STATE_2)	/* digital gain control lock */
> 
> WARNING: do not add new typedefs
> #40893: drivers/media/dvb-frontends/drx39xyj/drxj.h:114:
> +	typedef enum {
> 
> WARNING: line over 80 characters
> #40909: drivers/media/dvb-frontends/drx39xyj/drxj.h:130:
> +		DRXJ_CFG_ATV_OUTPUT,	/* also for FM (SIF control) but not likely */
> 
> WARNING: line over 80 characters
> #40912: drivers/media/dvb-frontends/drx39xyj/drxj.h:133:
> +		DRXJ_CFG_ATV_AGC_STATUS,	/* also for FM ( IF,RF, audioAGC ) */
> 
> WARNING: do not add new typedefs
> #40929: drivers/media/dvb-frontends/drx39xyj/drxj.h:146:
> +	typedef enum DRXJCfgSmartAntIO_t {
> 
> WARNING: do not add new typedefs
> #40942: drivers/media/dvb-frontends/drx39xyj/drxj.h:155:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #40956: drivers/media/dvb-frontends/drx39xyj/drxj.h:164:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #40973: drivers/media/dvb-frontends/drx39xyj/drxj.h:176:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #40994: drivers/media/dvb-frontends/drx39xyj/drxj.h:186:
> +	typedef struct {
> 
> WARNING: line over 80 characters
> #40995: drivers/media/dvb-frontends/drx39xyj/drxj.h:187:
> +		DRXStandard_t standard;	/* standard for which these settings apply */
> 
> WARNING: line over 80 characters
> #41002: drivers/media/dvb-frontends/drx39xyj/drxj.h:194:
> +		u16_t cutOffCurrent;	/* rf-agc is accelerated if output current
> 
> WARNING: line over 80 characters
> #41003: drivers/media/dvb-frontends/drx39xyj/drxj.h:195:
> +					   is below cut-off current                */
> 
> WARNING: do not add new typedefs
> #41017: drivers/media/dvb-frontends/drx39xyj/drxj.h:204:
> +	typedef struct {
> 
> WARNING: line over 80 characters
> #41018: drivers/media/dvb-frontends/drx39xyj/drxj.h:205:
> +		DRXStandard_t standard;	/* standard to which these settings apply */
> 
> WARNING: line over 80 characters
> #41019: drivers/media/dvb-frontends/drx39xyj/drxj.h:206:
> +		u16_t reference;	/* pre SAW reference value, range 0 .. 31 */
> 
> WARNING: line over 80 characters
> #41020: drivers/media/dvb-frontends/drx39xyj/drxj.h:207:
> +		Bool_t usePreSaw;	/* TRUE algorithms must use pre SAW sense */
> 
> WARNING: do not add new typedefs
> #41033: drivers/media/dvb-frontends/drx39xyj/drxj.h:216:
> +	typedef struct {
> 
> WARNING: line over 80 characters
> #41034: drivers/media/dvb-frontends/drx39xyj/drxj.h:217:
> +		DRXStandard_t standard;	/* standard to which these settings apply */
> 
> WARNING: line over 80 characters
> #41035: drivers/media/dvb-frontends/drx39xyj/drxj.h:218:
> +		u16_t gain;	/* gain in 0.1 dB steps, DRXJ range 140 .. 335 */
> 
> WARNING: do not add new typedefs
> #41051: drivers/media/dvb-frontends/drx39xyj/drxj.h:228:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #41071: drivers/media/dvb-frontends/drx39xyj/drxj.h:245:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #41085: drivers/media/dvb-frontends/drx39xyj/drxj.h:255:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #41104: drivers/media/dvb-frontends/drx39xyj/drxj.h:265:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #41126: drivers/media/dvb-frontends/drx39xyj/drxj.h:281:
> +	typedef struct {
> 
> WARNING: line over 80 characters
> #41127: drivers/media/dvb-frontends/drx39xyj/drxj.h:282:
> +		Bool_t disableTEIHandling;	      /**< if TRUE pass (not change) TEI bit */
> 
> WARNING: line over 80 characters
> #41130: drivers/media/dvb-frontends/drx39xyj/drxj.h:285:
> +						      /**< set MPEG output clock rate that overwirtes the derived one from symbol rate */
> 
> WARNING: do not add new typedefs
> #41144: drivers/media/dvb-frontends/drx39xyj/drxj.h:293:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #41159: drivers/media/dvb-frontends/drx39xyj/drxj.h:304:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #41172: drivers/media/dvb-frontends/drx39xyj/drxj.h:313:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #41186: drivers/media/dvb-frontends/drx39xyj/drxj.h:323:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #41207: drivers/media/dvb-frontends/drx39xyj/drxj.h:342:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #41228: drivers/media/dvb-frontends/drx39xyj/drxj.h:356:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #41245: drivers/media/dvb-frontends/drx39xyj/drxj.h:367:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #41265: drivers/media/dvb-frontends/drx39xyj/drxj.h:377:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #41288: drivers/media/dvb-frontends/drx39xyj/drxj.h:397:
> +	typedef enum {
> 
> WARNING: do not add new typedefs
> #41305: drivers/media/dvb-frontends/drx39xyj/drxj.h:409:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #41324: drivers/media/dvb-frontends/drx39xyj/drxj.h:419:
> +	typedef struct {
> 
> WARNING: do not add new typedefs
> #41463: drivers/media/dvb-frontends/drx39xyj/drxj.h:448:
> +	typedef struct {
> 
> WARNING: line over 80 characters
> #41477: drivers/media/dvb-frontends/drx39xyj/drxj.h:462:
> +		Bool_t mirrorFreqSpectOOB;/**< tuner inversion (TRUE = tuner mirrors the signal */
> 
> WARNING: line over 80 characters
> #41480: drivers/media/dvb-frontends/drx39xyj/drxj.h:465:
> +		DRXStandard_t standard;	  /**< current standard information                     */
> 
> WARNING: line over 80 characters
> #41482: drivers/media/dvb-frontends/drx39xyj/drxj.h:467:
> +					  /**< current constellation                            */
> 
> WARNING: line over 80 characters
> #41485: drivers/media/dvb-frontends/drx39xyj/drxj.h:470:
> +					  /**< current channel bandwidth                        */
> 
> WARNING: line over 80 characters
> #41489: drivers/media/dvb-frontends/drx39xyj/drxj.h:474:
> +		u32_t fecBitsDesired;	  /**< BER accounting period                            */
> 
> WARNING: line over 80 characters
> #41500: drivers/media/dvb-frontends/drx39xyj/drxj.h:485:
> +		u16_t HICfgTimingDiv;	  /**< HI Configure() parameter 2                       */
> 
> WARNING: line over 80 characters
> #41507: drivers/media/dvb-frontends/drx39xyj/drxj.h:492:
> +		DRXUIOMode_t uioSmaRxMode;/**< current mode of SmaRx pin                        */
> 
> WARNING: line over 80 characters
> #41513: drivers/media/dvb-frontends/drx39xyj/drxj.h:498:
> +		u32_t iqmFsRateOfs;	   /**< frequency shifter setting after setchannel      */
> 
> WARNING: line over 80 characters
> #41516: drivers/media/dvb-frontends/drx39xyj/drxj.h:501:
> +		u32_t iqmRcRateOfs;	   /**< frequency shifter setting after setchannel      */
> 
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation


-- 

Regards,
Mauro
