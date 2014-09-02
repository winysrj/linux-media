Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:49551 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518AbaIBLnp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Sep 2014 07:43:45 -0400
In-Reply-To: <20140902062822.GA2805@aika.logos.lan>
References: <20140825190109.GB3372@aika.discordia.loc> <5403358C.4070504@googlemail.com> <1409615932.1819.16.camel@palomino.walls.org> <20140902062822.GA2805@aika.logos.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: strange empia device
From: Andy Walls <awalls@md.metrocast.net>
Date: Tue, 02 Sep 2014 07:43:25 -0400
To: Lorenzo Marcantonio <l.marcantonio@logossrl.com>,
	linux-media@vger.kernel.org
Message-ID: <4bf257f7-0be4-4dd3-abe6-79ed20222819@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On September 2, 2014 2:28:23 AM EDT, Lorenzo Marcantonio <l.marcantonio@logossrl.com> wrote:
>On Mon, Sep 01, 2014 at 07:58:52PM -0400, Andy Walls wrote:
>> A Merlin firmware of 16 kB strongly suggests that this chip has an
>> integarted Conexant CX25843 (Merlin Audio + Thresher Video = Mako)
>> Broadtcast A/V decoder core.  The chip might only have a Merlin
>> integrated, but so far I've never encountered that.  It will be easy
>> enough to tell, if the Thresher registers don't respond or only
>respond
>> with junk.
>
>However I strongly suspect that these drivers are for a whole *family*
>of empia device. The oem ini by roxio talks about three different
>parts... probably they give one sys file for everyone and the oem
>customizes the ini.
>
>In short the merlin fw may not be actually used for *this* part but
>only
>for other empia devices/configurations.
>
>Otherwise I wonder *why* a fscking 1.5MB of sys driver for a mostly
>dumb
>capture device...

Yeah.  I guess you can analyze the USB captures of the Windows driver and see if it looks like cx25843 registers are being accessed.  If so, you are that much closer to a working linux driver.  If not, you still have an unknown decoder as a big hurdle.

Regards,
Andy
