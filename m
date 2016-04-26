Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34165 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbcDZPr4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2016 11:47:56 -0400
Subject: Re: [RFC PATCH v2 0/2] [media] tvp515p: Proposal for MC input
 connector support
To: linux-kernel@vger.kernel.org
References: <1460500973-9066-1-git-send-email-javier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <6da21733-8350-0dfd-68b7-f6385e283c9c@osg.samsung.com>
Date: Tue, 26 Apr 2016 11:47:46 -0400
MIME-Version: 1.0
In-Reply-To: <1460500973-9066-1-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/12/2016 06:42 PM, Javier Martinez Canillas wrote:
> Hello,
> 
> This is a second version of an RFC patch series that adds MC input connector
> support to the tvp5150 driver. The first RFC version was [0].
> 
> The patches are RFC because a previous version was merged and later reverted
> since the approach was found to be inadequate. So I preferred to post this
> approach as RFC to discuss it first.
> 
> The main difference with v1 is that a single sink pad is used for the tvp5150
> (instead of using a pad per each input pin) as suggested by Mauro and Hans.
> 
> The mc_nextgen_test dot output after applying the series can be found at [1]
> and the graph png generated using the dot tool is at [2].
> 
> I tested these patches on an IGEPv2 by capturing using both Composite inputs.
> 
> [0]: https://www.mail-archive.com/linux-media@vger.kernel.org/msg95389.html
> [1]: http://hastebin.com/yiduhonome.tex
> [2]: http://i.imgur.com/EyFtVtJ.png?1
> 
> Best regards,
> Javier
> 
> Changes in v2:
> - Remove from the changelog a mention of devices that multiplex the
>   physical RCA connectors to be used for the S-Video Y and C signals
>   since it's a special case and it doesn't really work on the IGEPv2.
> - Use a single sink pad for the demod and map the connectors as entities
>   so the mux is made via links. Suggested by Mauro and Hans.
> 
> Javier Martinez Canillas (2):
>   [media] tvp5150: Add input connectors DT bindings
>   [media] tvp5150: Replace connector support according to DT binding
> 
>  .../devicetree/bindings/media/i2c/tvp5150.txt      |  59 ++++++++
>  drivers/media/i2c/tvp5150.c                        | 155 +++++++++++++++------
>  2 files changed, 170 insertions(+), 44 deletions(-)
> 

Any comments about this series?

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
