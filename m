Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757018AbZLNLyJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2009 06:54:09 -0500
Message-ID: <4B262741.8050107@redhat.com>
Date: Mon, 14 Dec 2009 09:53:37 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jeremy Simmons <jeremy@impactmoto.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: Compile Error - ir-keytable
References: <A8BEBCEF90A5AC498E0DAEADEBB06AD7EA9C2BEB08@DC.impactmoto.com>
In-Reply-To: <A8BEBCEF90A5AC498E0DAEADEBB06AD7EA9C2BEB08@DC.impactmoto.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jeremy Simmons wrote:
> I'm having the same problem.  Any solution?

The new IR keycode is not compatible with any kernel older than 2.6.22. Also, newer
versions may even require latter codes, due to the sysfs code.

The fix is simple: 
	- Don't compile any code from ir-sysfs.c with older kernels;
	- Don't implement EVIO[G|S]KEYCODE ioctls;
	- Replace the new code to get a key by an old code at ir-keytable.c,
	  if kernels <= 2.6.22.

There's nothing reasonable that we can do to support keycode replacements
with older kernels, as the scancode tables were expanded to 16 bits (and 
will probably be expanded to 32 or 64 bits), and, with the legacy kernels,
the scancode/keycode table needs to be an array of the size of the scancode space.
So, a keycode table for 32 bits would waste 4Gb of ram (while we're still using
16 bits, the table won't be that big, but as we expect to soon support
RC6 protocols, it is not worth to port a code for 16 bits that will just
be dropped in a month or two).

Due to that, the support for < 2.6.22 kernels will provide a limited IR
code, after the backport: just the bundled IR will work.

I asked Douglas to do this backport after I finish the main changes at the module.

He'll likely start looking on it soon, as I've merged late yesterday the changes.

> 
> -Jeremy
> 
> 
> 
> 
> ________________________________________
> * Subject: Compile Error - ir-keytable 
> * From: David Carlo <dcarlo@xxxxxxxxxxxx> 
> * Date: Wed, 2 Dec 2009 11:56:22 -0500 
> ________________________________________
> Hello.  I'm compiling the v4l kernel drivers in an attempt to use my hdpvr
> with CentOS 5.4.  When I compile v4l, I'm getting this error:
> 
> =============================================================================
> <snip>
>   CC [M]  /usr/local/src/v4l-dvb/v4l/ir-functions.o
>   CC [M]  /usr/local/src/v4l-dvb/v4l/ir-keymaps.o
>   CC [M]  /usr/local/src/v4l-dvb/v4l/ir-keytable.o
> /usr/local/src/v4l-dvb/v4l/ir-keytable.c: In function
> 'ir_g_keycode_from_table':
> /usr/local/src/v4l-dvb/v4l/ir-keytable.c:181: error: implicit declaration of
> function 'input_get_drvdata'
> /usr/local/src/v4l-dvb/v4l/ir-keytable.c:181: warning: initialization makes
> pointer from integer without a cast
> /usr/local/src/v4l-dvb/v4l/ir-keytable.c: In function 'ir_input_free':
> /usr/local/src/v4l-dvb/v4l/ir-keytable.c:236: warning: initialization makes
> pointer from integer without a cast
> make[3]: *** [/usr/local/src/v4l-dvb/v4l/ir-keytable.o] Error 1
> make[2]: *** [_module_/usr/local/src/v4l-dvb/v4l] Error 2
> make[2]: Leaving directory `/usr/src/kernels/2.6.18-164.6.1.el5-x86_64'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/usr/local/src/v4l-dvb/v4l'
> make: *** [all] Error 2
> =============================================================================
> 
> Here are the stats on my box:
>   CentOS 5.4 x86_64
>   kernel 2.6.18-164.6.1.el5-x86_64
>   gcc 4.1.2
> 
> Has anyone else seen this?
> 
>     --Dave
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

