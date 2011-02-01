Return-path: <mchehab@pedra>
Received: from web4.futuron.fi ([217.149.52.4]:41736 "EHLO web4.futuron.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab1BAPKV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Feb 2011 10:10:21 -0500
Message-ID: <4D480261.7010609@t3.fi>
Date: Tue, 01 Feb 2011 14:53:53 +0200
From: Teemu Tuominen <tux@t3.fi>
MIME-Version: 1.0
To: Neil MacMunn <neil@gumstix.com>
CC: linux-media@vger.kernel.org
Subject: Re: omap3-isp segfault
References: <4D4076C3.4080201@gumstix.com> <4D40CDB3.7090106@gumstix.com> <201101271328.05891.laurent.pinchart@ideasonboard.com> <4D41F54C.2030804@gumstix.com>
In-Reply-To: <4D41F54C.2030804@gumstix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 01/28/2011 12:44 AM, Neil MacMunn wrote:
> # gst-launch v4l2src device=/dev/video4 ! xvimagesink
>
> Does anybody know how I can capture images from the camera? From 
> previous posts it appears that I'm not the first to go through this 
> process.
>
> Thanks. Neil
>
>

Hi,

Afaik v4l2src does not support subdev's atm. There's though one gst 
source element that aims to be generic with MediaController and I assume 
its first of its kind. I'm working to integrate the thing into Meego 
from behalf of Nokia N900 adaptation team. See 'mcsrc' bundled with 
gst-nokia-videosrc 
(http://meego.gitorious.org/maemo-multimedia/gst-nokia-videosrc). It 
also deals with the pipeline setup (data/pipelines.conf) so no need to 
use media-ctl cli.

Br,
-Teemu
