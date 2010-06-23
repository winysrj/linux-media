Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53995 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab0FWSHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jun 2010 14:07:14 -0400
Received: by wyi11 with SMTP id 11so1029848wyi.19
        for <linux-media@vger.kernel.org>; Wed, 23 Jun 2010 11:07:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilGJyf4GAW0R4YWJdZp0xdY7NjLoLr2Bjlmx_Zd@mail.gmail.com>
References: <AANLkTikOFpM1eHJa9FM1v9PtEnDuJtaiEvbTQubTsQS0@mail.gmail.com>
	<AANLkTilGJyf4GAW0R4YWJdZp0xdY7NjLoLr2Bjlmx_Zd@mail.gmail.com>
Date: Wed, 23 Jun 2010 19:07:12 +0100
Message-ID: <AANLkTilY8_oki2_AWL5CSinAsP-g1m9-B-TsVtpQkg_P@mail.gmail.com>
Subject: Record from DVB tuner
From: Simon Liddicott <simon@liddicott.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Depending how you want to use it you may like getstream.
http://silicon-verl.de/home/flo/projects/streaming/

You set up a config file that specifies the adapter the channels and
the output (can be streamed or saved to file.

Or dvbstreamer
http://sourceforge.net/apps/mediawiki/dvbstreamer/index.php?title=Main_Page

This can have a config file but can also have its operation changed
while running.
Si.

On 23 June 2010 17:06, shacky <shacky83@gmail.com> wrote:
>
> Hi.
>
> I need to record some DVB channels from the command line using a
> supported DVB tuner PCI card on Linux Debian.
> I know I can tune the DVB adapter using dvbtools and record the raw
> input using cat from /dev/dvb/adapter0, but what about recording two
> or more different channels from the same multiplex?
> How I can do this from the command line?
> Could you help me please?
>
> Thank you very much!
> Bye.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
