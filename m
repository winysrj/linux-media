Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:51441 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab0A0SLi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 13:11:38 -0500
Message-ID: <4B6081D4.5070501@freemail.hu>
Date: Wed, 27 Jan 2010 19:11:32 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc_camera: match signedness of soc_camera_limit_side()
References: <4B5AFD11.6000907@freemail.hu> <Pine.LNX.4.64.1001271645440.5073@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1001271645440.5073@axis700.grange>
Content-Type: multipart/mixed;
 boundary="------------030302080805050100090202"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030302080805050100090202
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Guennadi Liakhovetski wrote:
> On Sat, 23 Jan 2010, Németh Márton wrote:
> 
>> From: Márton Németh <nm127@freemail.hu>
>>
>> The parameters of soc_camera_limit_side() are either a pointer to
>> a structure element from v4l2_rect, or constants. The structure elements
>> of the v4l2_rect are signed (see <linux/videodev2.h>) so do the computations
>> also with signed values.
>>
>> This will remove the following sparse warning (see "make C=1"):
>>  * incorrect type in argument 1 (different signedness)
>>        expected unsigned int *start
>>        got signed int *<noident>
> 
> Well, it is interesting, but insufficient. And, unfortunately, I don't 
> have a good (and easy) recipe for how to fix this properly.
> 
> The problem is, that in soc_camera_limit_side all tests and arithmetics 
> are performed with unsigned in mind, now, if you change them to signed, 
> think what happens, if some of them are negative. No, I don't know when 
> negative members of struct v4l2_rect make sense, having them signed 
> doesn't seem a very good idea to me. But they cannot be changed - that's a 
> part of the user-space API...
> 
> Casting all parameters inside that inline to unsigned would be way too 
> ugly. Maybe we could at least keep start_min, length_min, and length_max 
> unsigned, and only change start and length to signed, and only cast those 
> two inside the function. Then, if you grep through all the drivers, 
> there's only one location, where soc_camera_limit_side() is called with 
> the latter 3 parameters not constant - two calls in 
> sh_mobile_ceu_camera.c. So, to keep sparse happy, you'd have to cast 
> there. Ideally, you would also add checks there for negative values...

I'll have a look to see what can be done to handle the negative values properly.

>> Signed-off-by: Márton Németh <nm127@freemail.hu>
>> ---
>> diff -r 2a50a0a1c951 linux/include/media/soc_camera.h
>> --- a/linux/include/media/soc_camera.h	Sat Jan 23 00:14:32 2010 -0200
>> +++ b/linux/include/media/soc_camera.h	Sat Jan 23 10:09:41 2010 +0100
>> @@ -264,9 +264,8 @@
>>  		common_flags;
>>  }
>>
>> -static inline void soc_camera_limit_side(unsigned int *start,
>> -		unsigned int *length, unsigned int start_min,
>> -		unsigned int length_min, unsigned int length_max)
>> +static inline void soc_camera_limit_side(int *start, int *length,
>> +		int start_min, int length_min, int length_max)
>>  {
>>  	if (*length < length_min)
>>  		*length = length_min;
>> diff -r 2a50a0a1c951 linux/drivers/media/video/rj54n1cb0c.c
>> --- a/linux/drivers/media/video/rj54n1cb0c.c	Sat Jan 23 00:14:32 2010 -0200
>> +++ b/linux/drivers/media/video/rj54n1cb0c.c	Sat Jan 23 10:09:41 2010 +0100
>> @@ -555,15 +555,15 @@
>>  	return ret;
>>  }
>>
>> -static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
>> -			       u32 *out_w, u32 *out_h);
>> +static int rj54n1_sensor_scale(struct v4l2_subdev *sd, s32 *in_w, s32 *in_h,
>> +			       s32 *out_w, s32 *out_h);
>>
>>  static int rj54n1_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>>  {
>>  	struct i2c_client *client = sd->priv;
>>  	struct rj54n1 *rj54n1 = to_rj54n1(client);
>>  	struct v4l2_rect *rect = &a->c;
>> -	unsigned int dummy = 0, output_w, output_h,
>> +	int dummy = 0, output_w, output_h,
>>  		input_w = rect->width, input_h = rect->height;
>>  	int ret;
> 
> And these:
> 
> 	if (output_w > max(512U, input_w / 2)) {
> 	if (output_h > max(384U, input_h / 2)) {
> 
> would now produce compiler warnings... Have you actually tried to compile 
> your patch? You'll also have to change formats in dev_dbg() calls here...

Interesting to hear about compiler warnings. I don't get them if I apply the patch
on top of version 14064:31eaa9423f98 of http://linuxtv.org/hg/v4l-dvb/  . What
is your compiler version?

I used the attached configuration. Maybe some other options has to be
turned on?

localhost:/usr/src/linuxtv.org/v4l-dvb$ patch -p1 <../soc_camera_signedness.patch
patching file linux/include/media/soc_camera.h
patching file linux/drivers/media/video/rj54n1cb0c.c
localhost:/usr/src/linuxtv.org/v4l-dvb$ make C=1 2>&1 |tee result1.txt
make -C /usr/src/linuxtv.org/v4l-dvb/v4l
make[1]: Entering directory `/usr/src/linuxtv.org/v4l-dvb/v4l'
creating symbolic links...
make -C firmware prep
make[2]: Entering directory `/usr/src/linuxtv.org/v4l-dvb/v4l/firmware'
make[2]: Leaving directory `/usr/src/linuxtv.org/v4l-dvb/v4l/firmware'
make -C firmware
make[2]: Entering directory `/usr/src/linuxtv.org/v4l-dvb/v4l/firmware'
make[2]: Nothing to be done for `default'.
make[2]: Leaving directory `/usr/src/linuxtv.org/v4l-dvb/v4l/firmware'
Kernel build directory is /lib/modules/2.6.33-rc4/build
make -C /lib/modules/2.6.33-rc4/build SUBDIRS=/usr/src/linuxtv.org/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/linuxtv.org/pinchartl/uvcvideo/v4l-dvb'
  CHECK   /usr/src/linuxtv.org/v4l-dvb/v4l/mt9m001.c
  CC [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/mt9m001.o
  CHECK   /usr/src/linuxtv.org/v4l-dvb/v4l/mt9m111.c
  CC [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/mt9m111.o
  CHECK   /usr/src/linuxtv.org/v4l-dvb/v4l/mt9t031.c
  CC [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/mt9t031.o
  CHECK   /usr/src/linuxtv.org/v4l-dvb/v4l/mt9t112.c
  CC [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/mt9t112.o
  CHECK   /usr/src/linuxtv.org/v4l-dvb/v4l/mt9v022.c
  CC [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/mt9v022.o
  CHECK   /usr/src/linuxtv.org/v4l-dvb/v4l/ov772x.c
  CC [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/ov772x.o
  CHECK   /usr/src/linuxtv.org/v4l-dvb/v4l/ov9640.c
  CC [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/ov9640.o
  CHECK   /usr/src/linuxtv.org/v4l-dvb/v4l/rj54n1cb0c.c
  CC [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/rj54n1cb0c.o
  CHECK   /usr/src/linuxtv.org/v4l-dvb/v4l/tw9910.c
  CC [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/tw9910.o
  CHECK   /usr/src/linuxtv.org/v4l-dvb/v4l/soc_camera.c
  CC [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/soc_camera.o
  CHECK   /usr/src/linuxtv.org/v4l-dvb/v4l/soc_camera_platform.c
  CC [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/soc_camera_platform.o
  Building modules, stage 2.
  MODPOST 28 modules
  LD [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/mt9m001.ko
  LD [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/mt9m111.ko
  LD [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/mt9t031.ko
  LD [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/mt9t112.ko
  LD [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/mt9v022.ko
  LD [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/ov772x.ko
  LD [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/ov9640.ko
  LD [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/rj54n1cb0c.ko
  LD [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/soc_camera.ko
  LD [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/soc_camera_platform.ko
  LD [M]  /usr/src/linuxtv.org/v4l-dvb/v4l/tw9910.ko
make[2]: Leaving directory `/usr/src/linuxtv.org/pinchartl/uvcvideo/v4l-dvb'
./scripts/rmmod.pl check
found 28 modules
make[1]: Leaving directory `/usr/src/linuxtv.org/v4l-dvb/v4l'
nmarci@asus-eeepc:/usr/src/linuxtv.org/v4l-dvb$ gcc --version
gcc (Debian 4.3.4-6) 4.3.4
Copyright (C) 2008 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

> 
>> @@ -638,8 +638,8 @@
>>   * the output one, updates the window sizes and returns an error or the resize
>>   * coefficient on success. Note: we only use the "Fixed Scaling" on this camera.
>>   */
>> -static int rj54n1_sensor_scale(struct v4l2_subdev *sd, u32 *in_w, u32 *in_h,
>> -			       u32 *out_w, u32 *out_h)
>> +static int rj54n1_sensor_scale(struct v4l2_subdev *sd, s32 *in_w, s32 *in_h,
>> +			       s32 *out_w, s32 *out_h)
>>  {
>>  	struct i2c_client *client = sd->priv;
>>  	struct rj54n1 *rj54n1 = to_rj54n1(client);
>> @@ -1017,7 +1017,7 @@
>>  	struct i2c_client *client = sd->priv;
>>  	struct rj54n1 *rj54n1 = to_rj54n1(client);
>>  	const struct rj54n1_datafmt *fmt;
>> -	unsigned int output_w, output_h, max_w, max_h,
>> +	int output_w, output_h, max_w, max_h,
>>  		input_w = rj54n1->rect.width, input_h = rj54n1->rect.height;
>>  	int ret;
> 
> and here.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 
> 

Regards,

	Márton Németh

--------------030302080805050100090202
Content-Type: text/plain;
 name=".config"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename=".config"

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIG1ha2UgY29uZmlnOiBkb24ndCBlZGl0CiMg
TGludXgga2VybmVsIHZlcnNpb246IEtFUk5FTFZFUlNJT04KIyBXZWQgSmFuIDI3IDE4OjU4
OjI0IDIwMTAKIwojIENPTkZJR19TTkRfTUlSTyBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVD15
CkNPTkZJR19VU0I9bQpDT05GSUdfRldfTE9BREVSPXkKIyBDT05GSUdfU1BBUkM2NCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BMQVRfTTMyNzAwVVQgaXMgbm90IHNldAojIENPTkZJR19TTkRf
Rk04MDEgaXMgbm90IHNldApDT05GSUdfRkJfQ0ZCX0lNQUdFQkxJVD15CiMgQ09ORklHX0dQ
SU9fUENBOTUzWCBpcyBub3Qgc2V0CiMgQ09ORklHX0hBVkVfQ0xLIGlzIG5vdCBzZXQKIyBD
T05GSUdfRklRIGlzIG5vdCBzZXQKQ09ORklHX1NORD1tCiMgQ09ORklHX01UOU0wMDFfUENB
OTUzNl9TV0lUQ0ggaXMgbm90IHNldAojIENPTkZJR19BUkNIX09NQVAyIGlzIG5vdCBzZXQK
IyBDT05GSUdfU1BBUkMzMiBpcyBub3Qgc2V0CkNPTkZJR19JMkNfQUxHT0JJVD1tCiMgQ09O
RklHX1NORF9JU0EgaXMgbm90IHNldApDT05GSUdfSU5FVD15CkNPTkZJR19DUkMzMj15CkNP
TkZJR19TWVNGUz15CkNPTkZJR19NTUM9bQpDT05GSUdfSVNBPXkKQ09ORklHX1BDST15CkNP
TkZJR19QQVJQT1JUXzEyODQ9eQpDT05GSUdfRkJfQ0ZCX0ZJTExSRUNUPXkKIyBDT05GSUdf
TVQ5VjAyMl9QQ0E5NTM2X1NXSVRDSCBpcyBub3Qgc2V0CkNPTkZJR19WSVJUX1RPX0JVUz15
CkNPTkZJR19QQVJQT1JUPW0KIyBDT05GSUdfQVJDSF9EQVZJTkNJX0RNNjQ0eCBpcyBub3Qg
c2V0CiMgQ09ORklHX0ZJUkVXSVJFIGlzIG5vdCBzZXQKQ09ORklHX05FVD15CiMgQ09ORklH
X0FSQ0hfREFWSU5DSSBpcyBub3Qgc2V0CkNPTkZJR19GQl9DRkJfQ09QWUFSRUE9eQojIENP
TkZJR19QWEEyN3ggaXMgbm90IHNldAojIENPTkZJR19TR0lfSVAyMiBpcyBub3Qgc2V0CkNP
TkZJR19JMkM9bQojIENPTkZJR19BUkNIX0RBVklOQ0lfRE0zNTUgaXMgbm90IHNldApDT05G
SUdfTU9EVUxFUz15CiMgQ09ORklHX1RVTkVSX1hDMjAyOCBpcyBub3Qgc2V0CkNPTkZJR19I
QVNfSU9NRU09eQojIENPTkZJR19NQUNIX0RBVklOQ0lfRE02NDY3X0VWTSBpcyBub3Qgc2V0
CkNPTkZJR19IQVNfRE1BPXkKQ09ORklHX0ZCPXkKIyBDT05GSUdfQVJDSF9NWDEgaXMgbm90
IHNldAojIENPTkZJR19TT05ZX0xBUFRPUCBpcyBub3Qgc2V0CiMgQ09ORklHX01YM19JUFUg
aXMgbm90IHNldApDT05GSUdfU05EX1BDTT1tCkNPTkZJR19FWFBFUklNRU5UQUw9eQojIENP
TkZJR19NMzJSIGlzIG5vdCBzZXQKIyBDT05GSUdfSUVFRTEzOTQgaXMgbm90IHNldAojIENP
TkZJR19WSURFT19LRVJORUxfVkVSU0lPTiBpcyBub3Qgc2V0CkNPTkZJR19NRURJQV9TVVBQ
T1JUPW0KCiMKIyBNdWx0aW1lZGlhIGNvcmUgc3VwcG9ydAojCkNPTkZJR19WSURFT19ERVY9
bQpDT05GSUdfVklERU9fVjRMMl9DT01NT049bQojIENPTkZJR19WSURFT19BTExPV19WNEwx
IGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fVjRMMV9DT01QQVQgaXMgbm90IHNldAojIENP
TkZJR19EVkJfQ09SRSBpcyBub3Qgc2V0CkNPTkZJR19WSURFT19NRURJQT1tCgojCiMgTXVs
dGltZWRpYSBkcml2ZXJzCiMKQ09ORklHX0lSX0NPUkU9bQpDT05GSUdfVklERU9fSVI9bQoj
IENPTkZJR19NRURJQV9BVFRBQ0ggaXMgbm90IHNldApDT05GSUdfTUVESUFfVFVORVI9bQoj
IENPTkZJR19NRURJQV9UVU5FUl9DVVNUT01JU0UgaXMgbm90IHNldApDT05GSUdfTUVESUFf
VFVORVJfU0lNUExFPW0KQ09ORklHX01FRElBX1RVTkVSX1REQTgyOTA9bQpDT05GSUdfTUVE
SUFfVFVORVJfVERBOTg4Nz1tCkNPTkZJR19NRURJQV9UVU5FUl9URUE1NzYxPW0KQ09ORklH
X01FRElBX1RVTkVSX1RFQTU3Njc9bQpDT05GSUdfTUVESUFfVFVORVJfTVQyMFhYPW0KQ09O
RklHX01FRElBX1RVTkVSX1hDMjAyOD1tCkNPTkZJR19NRURJQV9UVU5FUl9YQzUwMDA9bQpD
T05GSUdfTUVESUFfVFVORVJfTUM0NFM4MDM9bQpDT05GSUdfVklERU9fVjRMMj1tCkNPTkZJ
R19WSURFT0JVRl9HRU49bQpDT05GSUdfVklERU9fQ0FQVFVSRV9EUklWRVJTPXkKIyBDT05G
SUdfVklERU9fQURWX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fRklYRURfTUlO
T1JfUkFOR0VTIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fSEVMUEVSX0NISVBTX0FVVE8g
aXMgbm90IHNldAojIENPTkZJR19WSURFT19JUl9JMkMgaXMgbm90IHNldAoKIwojIEVuY29k
ZXJzL2RlY29kZXJzIGFuZCBvdGhlciBoZWxwZXIgY2hpcHMKIwoKIwojIEF1ZGlvIGRlY29k
ZXJzCiMKIyBDT05GSUdfVklERU9fVFZBVURJTyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVP
X1REQTc0MzIgaXMgbm90IHNldAojIENPTkZJR19WSURFT19UREE5ODQwIGlzIG5vdCBzZXQK
IyBDT05GSUdfVklERU9fVERBOTg3NSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1RFQTY0
MTVDIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fVEVBNjQyMCBpcyBub3Qgc2V0CiMgQ09O
RklHX1ZJREVPX01TUDM0MDAgaXMgbm90IHNldAojIENPTkZJR19WSURFT19DUzUzNDUgaXMg
bm90IHNldAojIENPTkZJR19WSURFT19DUzUzTDMyQSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJ
REVPX001Mjc5MCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1RMVjMyMEFJQzIzQiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1ZJREVPX1dNODc3NSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVP
X1dNODczOSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1ZQMjdTTVBYIGlzIG5vdCBzZXQK
CiMKIyBSRFMgZGVjb2RlcnMKIwojIENPTkZJR19WSURFT19TQUE2NTg4IGlzIG5vdCBzZXQK
CiMKIyBWaWRlbyBkZWNvZGVycwojCiMgQ09ORklHX1ZJREVPX0FEVjcxODAgaXMgbm90IHNl
dAojIENPTkZJR19WSURFT19CVDgxOSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0JUODU2
IGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fQlQ4NjYgaXMgbm90IHNldAojIENPTkZJR19W
SURFT19LUzAxMjcgaXMgbm90IHNldAojIENPTkZJR19WSURFT19PVjc2NzAgaXMgbm90IHNl
dAojIENPTkZJR19WSURFT19NVDlWMDExIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fVENN
ODI1WCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1NBQTcxMTAgaXMgbm90IHNldAojIENP
TkZJR19WSURFT19TQUE3MTFYIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fU0FBNzE3WCBp
cyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1RWUDUxNFggaXMgbm90IHNldAojIENPTkZJR19W
SURFT19UVlA1MTUwIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fVlBYMzIyMCBpcyBub3Qg
c2V0CgojCiMgVmlkZW8gYW5kIGF1ZGlvIGRlY29kZXJzCiMKIyBDT05GSUdfVklERU9fQ1gy
NTg0MCBpcyBub3Qgc2V0CgojCiMgTVBFRyB2aWRlbyBlbmNvZGVycwojCiMgQ09ORklHX1ZJ
REVPX0NYMjM0MVggaXMgbm90IHNldAoKIwojIFZpZGVvIGVuY29kZXJzCiMKIyBDT05GSUdf
VklERU9fU0FBNzEyNyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1NBQTcxODUgaXMgbm90
IHNldAojIENPTkZJR19WSURFT19BRFY3MTcwIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9f
QURWNzE3NSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX1RIUzczMDMgaXMgbm90IHNldAoj
IENPTkZJR19WSURFT19BRFY3MzQzIGlzIG5vdCBzZXQKCiMKIyBWaWRlbyBpbXByb3ZlbWVu
dCBjaGlwcwojCiMgQ09ORklHX1ZJREVPX1VQRDY0MDMxQSBpcyBub3Qgc2V0CiMgQ09ORklH
X1ZJREVPX1VQRDY0MDgzIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fVklWSSBpcyBub3Qg
c2V0CiMgQ09ORklHX1ZJREVPX0JUODQ4IGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fUE1T
IGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fU0FBNTI0NkEgaXMgbm90IHNldAojIENPTkZJ
R19WSURFT19TQUE1MjQ5IGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fWk9SQU4gaXMgbm90
IHNldAojIENPTkZJR19WSURFT19TQUE3MTM0IGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9f
SEVYSVVNX09SSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fSEVYSVVNX0dFTUlOSSBp
cyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0NYODggaXMgbm90IHNldAojIENPTkZJR19WSURF
T19JVlRWIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fQ0FGRV9DQ0lDIGlzIG5vdCBzZXQK
Q09ORklHX1NPQ19DQU1FUkE9bQpDT05GSUdfU09DX0NBTUVSQV9NVDlNMDAxPW0KQ09ORklH
X1NPQ19DQU1FUkFfTVQ5TTExMT1tCkNPTkZJR19TT0NfQ0FNRVJBX01UOVQwMzE9bQpDT05G
SUdfU09DX0NBTUVSQV9NVDlUMTEyPW0KQ09ORklHX1NPQ19DQU1FUkFfTVQ5VjAyMj1tCkNP
TkZJR19TT0NfQ0FNRVJBX1JKNTROMT1tCkNPTkZJR19TT0NfQ0FNRVJBX1RXOTkxMD1tCkNP
TkZJR19TT0NfQ0FNRVJBX1BMQVRGT1JNPW0KQ09ORklHX1NPQ19DQU1FUkFfT1Y3NzJYPW0K
Q09ORklHX1NPQ19DQU1FUkFfT1Y5NjQwPW0KIyBDT05GSUdfVjRMX1VTQl9EUklWRVJTIGlz
IG5vdCBzZXQKIyBDT05GSUdfUkFESU9fQURBUFRFUlMgaXMgbm90IHNldAojIENPTkZJR19E
QUIgaXMgbm90IHNldAoKIwojIEF1ZGlvIGRldmljZXMgZm9yIG11bHRpbWVkaWEKIwoKIwoj
IEFMU0Egc291bmQKIwojIENPTkZJR19TTkRfQlQ4N1ggaXMgbm90IHNldAojIENPTkZJR19T
VEFHSU5HIGlzIG5vdCBzZXQK
--------------030302080805050100090202--
