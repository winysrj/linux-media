Return-path: <linux-media-owner@vger.kernel.org>
Received: from www49.your-server.de ([213.133.104.49]:41298 "EHLO
	www49.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab0E0H0T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 03:26:19 -0400
Message-ID: <4BFE1984.4060205@motama.com>
Date: Thu, 27 May 2010 09:04:36 +0200
From: Michael Repplinger <repplinger@motama.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Subject: Re: full TS in Linux: known issue or new one?
References: <AANLkTin5w5l-v4MzMa05MaCjkq704RIGAmmr12JsE6eV@mail.gmail.com>
In-Reply-To: <AANLkTin5w5l-v4MzMa05MaCjkq704RIGAmmr12JsE6eV@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

regarding the described problems with capturing a full transponder from
a DVB device, I would like to ask if anyone is able to reproduce the
described problems?

We originally found that problem on a TBS DVB dual tuner board and are
able to reproduce these problems very quickly on all TBS cards we have.
Please note that Konstantin already described that this problem occurs
on several DVB boards as well. So it seems that there is a general
problem in DVB driver. It would be great if anybody could try to
reproduce the problem and report the results.

As far as I understand the problem, it could be a real issue and is not
only critical for applications that receive/process a full transponder.
If an application requests only specific PIDs, it seems that the driver
discards the garbage data in most cases because there is a lesser
propability that garbage start  with requested PIDs. However, since
garbage data can be received from the driver they could also start with
a valid/requested PID and thus affect all kind of applications that
receive/process DVB data. In this case the application would process
data that cannot be well interpreted which cause a very undefined 
behavior or even damage at the client side (e.g., interpreting garbage
data as audio).

So any help, suggestions, or reports if the problem can be reproduced
(or not) would be appreciated,

Thanks,
  Michael Repplinger


Konstantin Dimitrov wrote:
> hello All,
>
> the issue in question is that in case full TS is captured immediately
> after lock ( without some delay ) then garbage data ( that don't
> belong to the TS ) are introduced in the stream. initially Michael
> Repplinger noticed the problem and told me about it. also, he made
> test script ( 'run_szap-s2_adapter0_record_dvbsnoop.sh' ) for
> reproducing the problem easily ( you can find it in the attachment, i
> made some very small changed to it compared to the original script).
>
> so, basically, the test script 'szap-s2' to first transponder in your
> 'channel.conf' file, use 'dvbsnoop' to dump the full TS from that
> transponder to a file for 30 seconds, then 'szap-s2' to second
> transponder in your 'channel.conf' file, use 'dvbsnoop' again to dump
> the full TS to another file for 30 seconds and repeats this in endless
> loop. if there is no delay ( 'sleep 0' ) or delay is less than 5
> seconds ( at least on my setup those are delays i measured ) between
> executing 'szap-s2' and 'dvbsnoop' then captured stream contains some
> additional data that don't belong there, i.e. garbage and you can
> confirmed it with any TS analyzer tool or just use the attached
> 'test_file_with_dvbsnoop.sh' that Michael Repplinger prepared.
>
> i've already tested about 10 DVB devices from different manufacturers
> using completely different chips and PCI or PCIe interface and even
> USB interface, just for completeness here is what i've already tested:
>
> - Philips/NXP SAA7146 bridge driver
> - B2C2 Flexcop IIb PCI bridge driver (put in full TS mode with
> 'options b2c2_flexcop_pci enable_pid_filtering=0')
> - Booktree bt8xx bridge driver
> - Conexant cx88 bridge driver
> - Conexant cx23885 bridge driver
> - all USB DVB devices i have (all of them use Cypress USB controller)
>
> and with all of the above i can reproduce the problem using
> 'run_szap-s2_adapter0_record_dvbsnoop.sh' script. however, it seems
> SAA7146 is somehow better than the others, because sometimes it works
> good, i.e. captures correct data even without any delay between
> executing 'szap-s2' and 'dvbsnoop'.
>
> so, any ideas, please, either for what could be the root cause for the
> problem or for acceptable workaround? it seems to me at least at the
> moment it's a general problem with Linux DVB, but maybe it's known
> issue and someone knows more about it.
>
> many thanks,
> konstantin
>   


