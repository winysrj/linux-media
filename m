Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:43149 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752543AbdLUU20 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 15:28:26 -0500
Date: Thu, 21 Dec 2017 18:28:17 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH v6 0/6] V4L2 Explicit Synchronization
Message-ID: <20171221202817.GA12003@jade>
References: <20171211182741.29712-1-gustavo@padovan.org>
 <20171221164931.25064f63@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20171221164931.25064f63@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-12-21 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:

> Em Mon, 11 Dec 2017 16:27:35 -0200
> Gustavo Padovan <gustavo@padovan.org> escreveu:
> 
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > Hi,
> > 
> > One more iteration of the explicit fences patches, please refer
> > to the previous version[1] for more details about the general
> > mechanism
> > 
> > This version makes the patchset and the implementation much more
> > simple, to start we are not using a ordered capability anymore,
> > but instead we have a VIDIOC_ENUM_FMT flag to tell when the
> > queue in not ordered. Drivers with ordered queues/formats don't
> > need implement anything. See patches 1 and 2 for more details.
> > 
> > The implementation of in-fences and out-fences were condensed in
> > just patches 4 and 5, making it more self-contained and easy to
> > understand. See the patches for detailed changelog.
> > 
> > Please review! Thanks.
> 
> Hi Gustavo,
> 
> As I was afraid, the changes at the VB2 core makes it non-generic,
> breaking support for the DVB VB2 patchset. That's a branch with
> both patchsets applied:
> 
> 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=dvb_mmap%2bexplicit_fences
> 
> 
> With the explicit fences patchset, the DVB streaming breaks:
> 
> 	$ sudo perf stat dvbv5-zap -c ~/dvb_channel.conf "TV Brasilia RedeTV!"  -o /dev/null -t120 -R
> 	Usando demux 'dvb0.demux0'
> 	lendo canais do arquivo  '/home/mchehab/dvb_channel.conf'
> 	sintonizando em 557142857 Hz
> 	PID de vídeo 273
> 	  dvb_set_pesfilter 273
> 	PID de áudio 274
> 	  dvb_set_pesfilter 274
> 	Travado  (0x1f) Sinal= -85,22dBm C/N= 18,57dB UCB= 8589933955 pós-BER= 0
> 	Travado  (0x1f) Sinal= -85,24dBm C/N= 18,57dB UCB= 8589933955 pós-BER= 0
> 	Gravação iniciada para o arquivo '/dev/null'
> 	ERRO:DMX_REQBUFS failed: error=-1 (Invalid argument)
> 	ERRO:[stream_to_file] Failed to setup buffers!!! (Invalid argument)
> 	start streaming!!!
> 	copied 0 bytes (0 Kbytes/sec)
> 	Travado  (0x1f) Sinal= -85,25dBm C/N= 18,57dB UCB= 8589933955 pós-BER= 0

I haven't tried it, not sure what could break it. I'll take a look on
it.

>  Performance counter stats for 'dvbv5-zap -c /home/mchehab/dvb_channel.conf TV Brasilia RedeTV! -o /dev/null -t120 -R':
> 
>        7.001647  task-clock-msecs         #      0.003 CPUs 
>             251  context-switches         #      0.036 M/sec
>              18  CPU-migrations           #      0.003 M/sec
>             181  page-faults              #      0.026 M/sec
>        17001058  cycles                   #   2428.151 M/sec
>        11342660  instructions             #      0.667 IPC  
>          349075  cache-references         #     49.856 M/sec
>           70802  cache-misses             #     10.112 M/sec
> 
>     2.133343557  seconds time elapsed
> 
> It also breaks support on V4L2, when fences is not used:
> 
> $ ./contrib/test/v4l2grab 
> (kernel crashes)
> 
> I don't have a serial console on this machine to print what's
> wrong, but clearly there's something not right there :-)

2 days ago I fixed the a crash when not using fences:

https://git.kernel.org/pub/scm/linux/kernel/git/padovan/linux.git/commit/?h=v4l2-fences&id=704419e59437e9f7bdc369b44a612685e8663880

Gustavo
