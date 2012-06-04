Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:60039 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754587Ab2FDPfk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2012 11:35:40 -0400
Message-ID: <4FCCD5C9.706@fisher-privat.net>
Date: Mon, 04 Jun 2012 17:35:37 +0200
From: Oleksij Rempel <bug-track@fisher-privat.net>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-uvc-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
	sakari.ailus@iki.fi,
	Youness Alaoui <youness.alaoui@collabora.co.uk>
Subject: Re: [RFC] Media controller entity information ioctl [was "Re: [patch]
 suggestion for media framework"]
References: <4FCB9C12.1@fisher-privat.net> <9993866.a3VUSWRbyi@avalon>
In-Reply-To: <9993866.a3VUSWRbyi@avalon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04.06.2012 16:02, Laurent Pinchart wrote:
> Hi Oleksiy,
> 
> Thank you for the patch.
> 
> [CC'ing linux-media]
> 
> On Sunday 03 June 2012 19:17:06 Oleksij Rempel wrote:
>> Hi Laurent,
>>
>> in attachment is a suggestion patch for media framework and a test
>> program which use this patch.
>>
>> Suddenly we still didn't solved the problem with finding of XU. You
>> know, the proper way to find them is guid (i do not need to explain this
>> :)). Since uvc devices starting to have more and complicated XUs, media
>> api is probably proper way to go - how you suggested.
>>
>> On the wiki of TexasInstruments i found some code examples, how they use
>> this api. And it looks like there is some desing differences between
>> OMPA drivers and UVC. It is easy to find proper entity name for omap
>> devices just by: "(!strcmp(entity[index].name, "OMAP3 ISP CCDC"))".
>> We can't do the same for UVC, current names are just "Extension %u". We
>> can put guid instead, but it will looks ugly and not really informative.
>> This is why i added new struct uvc_ext.
>>
>> If you do not agree with this patch, it will be good if you proved other
>> solution. This problem need to be solved.
> 
> The patch goes in the right direction, in that I think the media controller 
> API is the proper way to solve this problem. However, extending the 
> media_entity_desc structure with information about all possible kinds of 
> entities will not scale, especially given that an entity may need to expose 
> information related to multiple types (for instance an XU need to expose its 
> GUID, but also subdev-related information if it has a device node).
> 
> I've been thinking about adding a new ioctl to the media controller API for 
> some time now, to report advanced static information about entities.
> 
> The idea is that each entity would be allowed to report an arbitrary number of 
> static items. Items would have a type (for which we would likely need some 
> kind of central registry, possible with driver-specific types), a length and 
> data. The items would be static (registered an initialization time) and 
> aggregated in a single buffer that would be read in one go through a new 
> ioctl.
> 
> One important benefit of such an API would be to be able to report more than 
> one entity type per subdev using entity type items. Many entities serve 
> several purpose, for instance a sensor can integrate a flash controller. This 
> can't be reported with the current API, as subdevs have a single type. By 
> having several entity type items we could fix this issue.
> 
> Details remain to be drafted, but I'd like a feedback on the general approach.

Currently i can talk only about uvc :)
Normally entity sub/type can be created by driver and device where
documentation is available. For uvc it is not the case. If we get some
comlicated uvc device with decumentation about XU, we will need
userspace library to map all needed entities. But if you wont to make it
static, created on driver init, then we will need some kind of plugin
interface for uvcvideo.... (this sounds scary ;)) or remapable entities.

Then one more question:
for the case with uvcvideo + usb-audio, one of driver may reset complete
device if it get some timeout or error. Make it sense to use media api
to avoid it? For example uvcvideo set enitity state to busy, and if
audio need to reset it and handler is not usb-audio for busy device,
then it should notify handler...


-- 
Regards,
Oleksij
