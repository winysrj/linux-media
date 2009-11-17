Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39588 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbZKQX3i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 18:29:38 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 17 Nov 2009 17:29:35 -0600
Subject: RE: Help in adding documentation
Message-ID: <A69FA2915331DC488A831521EAE36FE401559C5D80@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE401559C59A2@dlee06.ent.ti.com>
 <20091117142820.1e62a362@pedra.chehab.org>
 <A69FA2915331DC488A831521EAE36FE401559C5A38@dlee06.ent.ti.com>
 <4B02E444.3020707@infradead.org>
In-Reply-To: <4B02E444.3020707@infradead.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Thanks to your help, I could finish my documentation today.

But I have another issue with the v4l2-apps.

When I do make apps, it doesn't seem to build. I get the following error
logs... Is this broken?

Thanks.
Murali

make -C /local/mkaricheri/davinci_git/video_timing/new_v4l2-dvb/v4l-dvb-aba823ecaea6/v4l apps
make[1]: Entering directory `/local/mkaricheri/davinci_git/video_timing/new_v4l2-dvb/v4l-dvb-aba823ecaea6/v4l'
make -C ../v4l2-apps
make[2]: Entering directory `/local/mkaricheri/davinci_git/video_timing/new_v4l2-dvb/v4l-dvb-aba823ecaea6/v4l2-apps'
if [ ! -d include ]; then \
	cp -r ../linux/include include ; \
	../v4l/scripts/headers_convert.pl `find include -type f` ; \
fi
make -C libv4l all
make[3]: Entering directory `/local/mkaricheri/davinci_git/video_timing/new_v4l2-dvb/v4l-dvb-aba823ecaea6/v4l2-apps/libv4l'
make -C libv4lconvert V4L2_LIB_VERSION=0.6.2-test all
make[4]: Entering directory `/local/mkaricheri/davinci_git/video_timing/new_v4l2-dvb/v4l-dvb-aba823ecaea6/v4l2-apps/libv4l/libv4lconvert'
cc -Wp,-MMD,"libv4lconvert.d",-MQ,"libv4lconvert.o",-MP -c -I../include -I../../../include -fvisibility=hidden -fPIC -DLIBDIR=\"/usr/local/lib\" -DLIBSUBDIR=\"libv4l\" -g -O1 -Wall -Wno-unused -Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes -o libv4lconvert.o libv4lconvert.c
In file included from libv4lconvert.c:25:
../include/libv4lconvert.h:100: warning: "struct v4l2_frmsizeenum" declared inside parameter list
../include/libv4lconvert.h:100: warning: its scope is only this definition or declaration, which is probably not what you want
../include/libv4lconvert.h:105: warning: "struct v4l2_frmivalenum" declared inside parameter list
In file included from libv4lconvert.c:26:
libv4lconvert-priv.h:129: error: field `framesizes' has incomplete type
libv4lconvert.c: In function `v4lconvert_get_framesizes':
libv4lconvert.c:1121: error: variable `frmsize' has initializer but incomplete type
libv4lconvert.c:1121: error: unknown field `pixel_format' specified in initializer
libv4lconvert.c:1121: warning: excess elements in struct initializer
libv4lconvert.c:1121: warning: (near initialization for `frmsize')
libv4lconvert.c:1121: error: storage size of 'frmsize' isn't known
libv4lconvert.c:1125: error: `VIDIOC_ENUM_FRAMESIZES' undeclared (first use in this function)
libv4lconvert.c:1125: error: (Each undeclared identifier is reported only once
libv4lconvert.c:1125: error: for each function it appears in.)
libv4lconvert.c:1135: error: `V4L2_FRMSIZE_TYPE_DISCRETE' undeclared (first use in this function)
libv4lconvert.c:1140: error: `V4L2_FRMSIZE_TYPE_CONTINUOUS' undeclared (first use in this function)
libv4lconvert.c:1141: error: `V4L2_FRMSIZE_TYPE_STEPWISE' undeclared (first use in this function)
libv4lconvert.c: In function `v4lconvert_enum_framesizes':
libv4lconvert.c:1180: error: dereferencing pointer to incomplete type
libv4lconvert.c:1185: error: `VIDIOC_ENUM_FRAMESIZES' undeclared (first use in this function)
libv4lconvert.c:1188: error: dereferencing pointer to incomplete type
libv4lconvert.c:1193: error: dereferencing pointer to incomplete type
libv4lconvert.c:1193: error: dereferencing pointer to incomplete type
libv4lconvert.c:1194: error: dereferencing pointer to incomplete type
libv4lconvert.c:1195: error: `V4L2_FRMSIZE_TYPE_DISCRETE' undeclared (first use in this function)
libv4lconvert.c:1196: error: dereferencing pointer to incomplete type
libv4lconvert.c:1196: error: dereferencing pointer to incomplete type
libv4lconvert.c:1198: error: dereferencing pointer to incomplete type
libv4lconvert.c:1199: error: dereferencing pointer to incomplete type
libv4lconvert.c:1201: error: `V4L2_FRMSIZE_TYPE_CONTINUOUS' undeclared (first use in this function)
libv4lconvert.c:1202: error: `V4L2_FRMSIZE_TYPE_STEPWISE' undeclared (first use in this function)
libv4lconvert.c:1203: error: dereferencing pointer to incomplete type
libv4lconvert.c:1203: error: dereferencing pointer to incomplete type
libv4lconvert.c: At top level:
libv4lconvert.c:1211: warning: "struct v4l2_frmivalenum" declared inside parameter list
libv4lconvert.c:1212: error: conflicting types for 'v4lconvert_enum_frameintervals'
../include/libv4lconvert.h:105: error: previous declaration of 'v4lconvert_enum_frameintervals' was here
libv4lconvert.c:1212: error: conflicting types for 'v4lconvert_enum_frameintervals'
../include/libv4lconvert.h:105: error: previous declaration of 'v4lconvert_enum_frameintervals' was here
libv4lconvert.c: In function `v4lconvert_enum_frameintervals':
libv4lconvert.c:1216: error: dereferencing pointer to incomplete type
libv4lconvert.c:1221: error: `VIDIOC_ENUM_FRAMEINTERVALS' undeclared (first use in this function)
libv4lconvert.c:1230: error: dereferencing pointer to incomplete type
libv4lconvert.c:1231: error: dereferencing pointer to incomplete type
libv4lconvert.c:1232: error: dereferencing pointer to incomplete type
libv4lconvert.c:1240: error: dereferencing pointer to incomplete type
libv4lconvert.c:1241: error: dereferencing pointer to incomplete type
libv4lconvert.c:1242: error: dereferencing pointer to incomplete type
libv4lconvert.c:1243: error: dereferencing pointer to incomplete type
libv4lconvert.c:1245: error: dereferencing pointer to incomplete type
libv4lconvert.c:1245: error: dereferencing pointer to incomplete type
libv4lconvert.c:1262: error: dereferencing pointer to incomplete type
libv4lconvert.c:1263: error: dereferencing pointer to incomplete type
libv4lconvert.c:1264: error: dereferencing pointer to incomplete type
libv4lconvert.c:1269: error: dereferencing pointer to incomplete type
libv4lconvert.c:1285: error: dereferencing pointer to incomplete type
libv4lconvert.c:1286: error: dereferencing pointer to incomplete type
libv4lconvert.c:1287: error: dereferencing pointer to incomplete type
make[4]: *** [libv4lconvert.o] Error 1
make[4]: Leaving directory `/local/mkaricheri/davinci_git/video_timing/new_v4l2-dvb/v4l-dvb-aba823ecaea6/v4l2-apps/libv4l/libv4lconvert'
make[3]: *** [all] Error 2
make[3]: Leaving directory `/local/mkaricheri/davinci_git/video_timing/new_v4l2-dvb/v4l-dvb-aba823ecaea6/v4l2-apps/libv4l'
make[2]: *** [all] Error 2
make[2]: Leaving directory `/local/mkaricheri/davinci_git/video_timing/new_v4l2-dvb/v4l-dvb-aba823ecaea6/v4l2-apps'
make[1]: *** [apps] Error 2
make[1]: Leaving directory `/local/mkaricheri/davinci_git/video_timing/new_v4l2-dvb/v4l-dvb-aba823ecaea6/v4l'
make: *** [apps] Error 2


Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Mauro Carvalho Chehab [mailto:mchehab@infradead.org]
>Sent: Tuesday, November 17, 2009 12:58 PM
>To: Karicheri, Muralidharan
>Cc: Hans Verkuil; linux-media@vger.kernel.org
>Subject: Re: Help in adding documentation
>
>Karicheri, Muralidharan escreveu:
>> Mauro,
>>
>> Thanks for your reply. I made progress after my email. My new file
>> is being processed by Makefile now. I have some issues with some
>> tags.
>>
>>> This probably means that videodev2.h has it defined, while you didn't
>have
>>
>> Do you mean videodev2.h.xml? I see there videodev2.h under linux/include.
>Do I need to copy my latest videodev2.h to that directory?
>
>videodev2.h.xml is generated automatically by Makefile, from videodev2.h.
>
>Basically, Makefile scripts will parse it, search for certain
>structs/enums/ioctls and
>generate videodev2.h.xml.
>
>What happens is that you likely declared the presets enum on videodev2.h,
>and the
>enum got detected, producing a <linkend> tag. However, as you didn't define
>the
>reference ID for that tag on your xml file, you got an error.
>>
>>> the
>>> link id created at the xml file you've created.
>>>
>>> You probably need a tag like:
>>>
>>> <table pgwide="1" frame="none" id="v4l2-dv-enum-presets">
>>> <!-- your enum table -->
>>> </table>
>>>
>>>
>>> Cheers,
>>> Mauro
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

