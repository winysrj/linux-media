Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35285 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab0AGXYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jan 2010 18:24:16 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 7 Jan 2010 17:24:07 -0600
Subject: building v4l-dvb - compilation error
Message-ID: <A69FA2915331DC488A831521EAE36FE40162D43370@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have installed mercurial and cloned the v4l-dvb tree. I tried doing a build as per instructions and I get the following error. Since I am in the process of validating my build environment, I am not sure if the following is a genuine build error or due to my environment...

Other questions I have are:-

1) I am just doing make. So does this build all v4l2 drivers?
2) Which target this build for?
3) What output this build create?
 
CC [M]  /local/mkaricheri/mercury/v4l-dvb/v4l/tuner-simple.o
In file included from /local/mkaricheri/mercury/v4l-dvb/v4l/tuner-simple.c:9:
/local/mkaricheri/mercury/v4l-dvb/v4l/compat.h:463: warning: "struct snd_card" d
eclared inside parameter list
/local/mkaricheri/mercury/v4l-dvb/v4l/compat.h:463: warning: its scope is only t
his definition or declaration, which is probably not what you want
/local/mkaricheri/mercury/v4l-dvb/v4l/tuner-simple.c:32: error: invalid lvalue i
n unary `&'
/local/mkaricheri/mercury/v4l-dvb/v4l/tuner-simple.c:32: error: initializer elem
ent is not constant
/local/mkaricheri/mercury/v4l-dvb/v4l/tuner-simple.c:32: error: (near initializa
tion for `__param_arr_atv_input.num')
/local/mkaricheri/mercury/v4l-dvb/v4l/tuner-simple.c:33: error: invalid lvalue i
n unary `&'
/local/mkaricheri/mercury/v4l-dvb/v4l/tuner-simple.c:33: error: initializer elem
ent is not constant
/local/mkaricheri/mercury/v4l-dvb/v4l/tuner-simple.c:33: error: (near initializa
tion for `__param_arr_dtv_input.num')
make[3]: *** [/local/mkaricheri/mercury/v4l-dvb/v4l/tuner-simple.o] Error 1
make[2]: *** [_module_/local/mkaricheri/mercury/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.9-55.0.12.EL-smp-i686'
make[1]: *** [default] Error 2


Murali Karicheri

