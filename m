Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50393 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811AbbHJMoS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 08:44:18 -0400
Message-ID: <55C89C86.2070707@xs4all.nl>
Date: Mon, 10 Aug 2015 14:43:50 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	media-workshop@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [RFC] Media graph flow for an hybrid device as discussed at the
 media workshop
References: <20150808083330.7daf111f@recife.lan>
In-Reply-To: <20150808083330.7daf111f@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 08/08/2015 01:33 PM, Mauro Carvalho Chehab wrote:
> During the discussions at the Media Workshop, we came with some dot files that
> would describe a hybrid PC-consumer TV stick with radio, analog video, analog
> TV and digital TV on it.
> 
> I consolidated all the dot files we've worked there, and added the
> connectors for RF, S-Video and Composite.
> 
> The dot file and the corresponding picture is at:
> 	http://linuxtv.org/downloads/presentations/mc_ws_2015/dvb-pipeline-v2.dot
> 	http://linuxtv.org/downloads/presentations/mc_ws_2015/dvb-pipeline-v2.png
> 
> As my plan is to start working on some real driver to produce such graph,
> please validate if the entities, interfaces, data links and interface links
> are correct, and if the namespace nomenclature is ok, or if I miss something.

This looks OK to me, except for one small detail: I wouldn't use the name
"Source entities" for connectors. Instead use "Connector entities" since
such entities correspond to actual real connectors on a backplane. A proper
source entity would be a sensor or test pattern generator. Which actually
can occur with the em28xx since it's used in webcams as well.

And a really, really small detail: in the legend the 'interface link' is an
arrow, but it should be a line, since there is no direction. The graph itself
is fine.

As you mentioned on irc, the v4l-subdevX nodes won't be created for this device
since all the configuration happens via the standard interfaces.

But if they were to be created, then they would appear where they are in this
example.

Regards,

	Hans
