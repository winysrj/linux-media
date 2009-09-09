Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp106.rog.mail.re2.yahoo.com ([68.142.225.204]:45354 "HELO
	smtp106.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751159AbZIIEZ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2009 00:25:57 -0400
Message-ID: <4AA72E57.6000304@rogers.com>
Date: Wed, 09 Sep 2009 00:25:59 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Peter Brouwer <pb.maillists@googlemail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: Question on video device in /dev for S460 card cx88
References: <4AA149C6.9070308@googlemail.com>
In-Reply-To: <4AA149C6.9070308@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Peter Brouwer wrote:
> Hello
>
> Quick question regarding video devices that show up when using a cx88
> base S460
> (tevii) DVB-S2 card.
>
> I see two devices in /dev
> /dev/video0 and /dev/vbi0 related to the cx88 based dvb-s2 card.
> What are those devices, is the video0 the video out of the card after the
> demuxer? If so, should that device not show up in /dev/dvb/adapterN ??
>
> What is the /dev/vbi0 device?
>
> Regards

I heavily modified/updated my previous link/answer I provided to this
question you posted earlier.  A more thorough answer can be found here:
http://www.linuxtv.org/wiki/index.php/Device_nodes_and_character_devices

Please review that, as it should make clear the answers to your questions.
