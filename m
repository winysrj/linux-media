Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1Kf0Vw-0007hc-17
	for linux-dvb@linuxtv.org; Mon, 15 Sep 2008 00:56:21 +0200
Date: Mon, 15 Sep 2008 00:55:38 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: =?ISO-8859-15?Q?Michael_M=FCller?= <mueller_michael@nikocity.de>
In-Reply-To: <20080914082131.GA12258@mueller_michael.de>
Message-ID: <alpine.LRH.1.10.0809150049000.7121@pub5.ifh.de>
References: <20080914082131.GA12258@mueller_michael.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="579716367-277567491-1221432555=:7121"
Cc: pboettcher@dibcom.fr, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Elgato EyeTV Diversity patch
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--579716367-277567491-1221432555=:7121
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by znsun1.ifh.de id m8EMtdWB014843

Hi Michael,

On Sun, 14 Sep 2008, Michael M=FCller wrote:
> Simply adding a new entry beside the Hauppauge Nova-T stick using the
> new ids didn't work. Using trail and error I was able to find the
> right combination. I also was able to activate the remote
> control. Since the other devices that use stk7070pd_frontend_attach0
> and stk7070pd_frontend_attach1 as frontends doesn't activate the RC I
> needed to start a section for my stick. If it doesn't hurt the other
> devices to have a RC defined perhaps you should combine them.

Yes, please do that. And send the patch again with your Signed-off-by-lin=
e=20
and both file-changes created with hg diff of the v4l-dvb repository.

> Although it is stated that the diversity mode is currentl not
> supported it seems to be necessary that both antenna plugs are
> connected. I have an active antenna and I thought that without
> diversity it would be the best to connect the antenna directly to the
> adapter that I want to use. But in this combination 'scan' only
> creates 'WARNING: >>> tuning failed!!!' messages. If I use the Y-cable
> to connect the antenna to both adapters scan is able to find the TV
> channels. Do you have an explanation for this behaviour?

As you might have noticed, pluging the hardware results in having two=20
/dev/dvb/adapters. Diversity is in fact disabled, but dual-mode (sometime=
s=20
referred as PVR) is activated by default.

Diversity actually is the combination of the signal resulting from two=20
different antennas (and tuners and demodulators). This is not yet=20
supported by LinuxTV-drivers.

> Are there plans to add support for the diversity mode?

Yes.

Thanks for your patch,
Patrick.
--579716367-277567491-1221432555=:7121
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--579716367-277567491-1221432555=:7121--
