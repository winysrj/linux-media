Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KxNlt-0004uS-Cg
	for linux-dvb@linuxtv.org; Tue, 04 Nov 2008 16:24:46 +0100
Received: by nf-out-0910.google.com with SMTP id g13so1508020nfb.11
	for <linux-dvb@linuxtv.org>; Tue, 04 Nov 2008 07:24:42 -0800 (PST)
Message-ID: <412bdbff0811040724x6118e213h4f4bc2900dcc31bb@mail.gmail.com>
Date: Tue, 4 Nov 2008 10:24:42 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: linuxtv@hotair.fastmail.co.uk
In-Reply-To: <1225811663.1701.1282927225@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <200811032211.41760.jareguero@telefonica.net>
	<49104A4D.2040609@iki.fi>
	<1225811663.1701.1282927225@webmail.messagingengine.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Nova-TD and I2C read/write failed
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Tue, Nov 4, 2008 at 10:14 AM, petercarm
<linuxtv@hotair.fastmail.co.uk> wrote:
> My build is gentoo with 2.6.25 kernel and mercurial V4L using
> dvb-usb-dib0700-1.10.fw   The Hauppauge Nova-TD USB stick shows a USB ID
> of 2040:5200.
>
> The card works for a few hours and then floods dmesg with "DiB0070 I2C
> write failed" messages.
>
> I've found plenty of passing references to this problem, but what do I
> need to do to get this working?
>
> Do I need to change to the 1.20 firmware?
>
> Where does dib0700_new_i2c_api.patch exist?  It is mentioned on the wiki
> but I haven't been able to find it anywhere.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

Hello Peter,

The new i2c API is merged into the v4l-dvb mainline, so there is no
need for a patch.  Also, the mainline requires 1.20 firmware, although
it turns out the remote control support is broken (Patrick and myself
are actively investigating this issue).

It would be worthwhile for you to update to the lastest v4l-dvb tree
and see if your situation improves.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
