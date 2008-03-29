Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1Jfiwe-00034Q-Uk
	for linux-dvb@linuxtv.org; Sat, 29 Mar 2008 22:50:38 +0100
Date: Sat, 29 Mar 2008 22:49:41 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Antti Palosaari <crope@iki.fi>
In-Reply-To: <47EC3BD4.3070307@iki.fi>
Message-ID: <Pine.LNX.4.64.0803292248590.26653@pub6.ifh.de>
References: <e44ae5e0712172128p4e1428aao493d0a1725b6fcd3@mail.gmail.com>
	<47EC3BD4.3070307@iki.fi>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org, ptay1685 <ptay1685@Bigpond.net.au>,
	k.bannister@ieee.org
Subject: Re: [linux-dvb] [PATCH] new USB-ID for Leadtek Winfast DTV was: Re:
 New Leadtek Winfast DTV Dongle working - with mods but no RC
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

Hi Antti,

Daryll Green was first - I committed his patch.

Sorry,
Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

On Fri, 28 Mar 2008, Antti Palosaari wrote:

> hello
> USB-ID for Leadtek Winfast DTV
>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
>
> Patch done against current development-tree at 
> http://linuxtv.org/hg/~pb/v4l-dvb/
> Patrick, could you check and add it?
>
> Could ptay1685 or John or some other test this?
>
> Keith Bannister wrote:
>>  I hopped onto the IRC channel and crope` (thanks mate) advised me to
>>  change dvb-usb-ids.h to
>>
>>  #define USB_PID_WINFAST_DTV_DONGLE_STK7700P        0x6f01
>
> Sorry, I forgot make patch earlier...
>
> regards
> Antti
> -- 
> http://palosaari.fi/
>


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
