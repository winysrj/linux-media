Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail203c25.carrierzone.com ([64.29.147.79])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxdreas@launchnet.com>) id 1K7dLM-0001sw-Pw
	for linux-dvb@linuxtv.org; Sat, 14 Jun 2008 23:31:34 +0200
Received: from hal9001 (208-201-228-169.adsl.dynamic.launchnet.com
	[208.201.228.169] (may be forged)) (authenticated bits=0)
	by mail203c25.carrierzone.com (8.13.6.20060614/8.13.1) with ESMTP id
	m5ELV7ow009699
	for <linux-dvb@linuxtv.org>; Sat, 14 Jun 2008 21:31:10 GMT
From: Andreas <linuxdreas@launchnet.com>
To: linux-dvb@linuxtv.org
Date: Sat, 14 Jun 2008 14:31:05 -0700
References: <20080613.201811.28932.1@webmail03.vgs.untd.com>
In-Reply-To: <20080613.201811.28932.1@webmail03.vgs.untd.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806141431.06495.linuxdreas@launchnet.com>
Subject: Re: [linux-dvb] extraction xc5000 firmware
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Am Freitag, 13. Juni 2008 18:18:11 schrieb kevrust@juno.com:
> Greetings!
>
> This is my first experience with Linux, and I am trying to set up a
> Pinnacle PCTV HD (800i) card in my new media center PC (Ubuntu Hardy
> Heron/ Mythbuntu), but I'm having a difficult time installing the xc5000
> firmware from your site. When I run the perl script , I consistently get
> the message: "Invalid zip archive, either corrupt or incorrect version",
> even though I have downloaded the .zip archive into the same directory as
> the script file. Could there be a problem with the script, or could my
> distro be somehow changing the zip file so that the perl script thinks it
> is corrupt? Or is there another way to extract the firmware to my machine
> (bearing in mind that I am a newbie, of course)

Kevin,
I use the same atsc card without any problems. You have either a corrupt zi=
p =

file, or the program md5sum (used by the script extract.sh) is not =

installed on your system (which is highly unlikely, but with Ubuntu, you =

never know).

If all else fails, I can email you the extracted firmware if you like.

-- =

Gru=DF
Andreas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
