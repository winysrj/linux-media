Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp04.wxs.nl ([195.121.247.13]:54107 "EHLO psmtp04.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944AbZKMQit (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 11:38:49 -0500
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp04.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0KT200BSC3KRMD@psmtp04.wxs.nl> for linux-media@vger.kernel.org;
 Fri, 13 Nov 2009 17:38:52 +0100 (MET)
Date: Fri, 13 Nov 2009 17:38:50 +0100
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: [linux-dvb] Organizing ALL device data in linuxtv wiki
In-reply-to: <20091113160850.GY31295@www.viadmin.org>
To: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Message-id: <4AFD8B9A.7000309@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20091112173130.GV31295@www.viadmin.org>
 <20091113160850.GY31295@www.viadmin.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Would it be possible to store this information in the CODE archives, and 
extract it from there ?
Right now, I end up putting essentially the same information into 
structures in the driver and into documentation.
This is hard to keep synchronised.

Basic information like device IDs, vendors, demod types, tuners, etc is 
already in place in the driver codes.

Getting data from the hg archives (including development branches) 
sounds like a cleaner solution.

H. Langos wrote:
> Hi Devin,
> 
> I'm sorry. I just realized that I was only subscribed to linux-dvb but 
> not to linux-media. I fixed that now but my reply to your emails will 
> not have the correct In-Reply-To/References headers.
> 
>> I have to wonder if maybe we are simply using the wrong tool for the
>> job.  Perhaps it would make sense to make a really simple web frontend
>> to a simple database for devices.  At least initially it would only
>> really need two tables.  Something along the lines of the following
> ...
>> A simple db frontend like the above would allow users to search on
>> most of the relevant properties they care about (seeing all devices by
>> a single manufacturer, looking up devices by USB ID or PCI ID, looking
>> for devices that support a certain standard, etc)
> 
> I've spent some time discussing the pro and contra of an external database
> versus a wiki based approach with some of the other wiki admins:
> http://www.linuxtv.org/wiki/index.php/User_talk:Hlangos#Further_ramblings...
> 
> The most important point there I guess is, that writing a database app is
> a piece of cake and a rather nice way of brushing up on one's SQL foo, 
> but keeping it structure-wise updated for years to come is hard and 
> boring work.
> 
> Also you have to keep in mind that your database app would need to have
> at leasts: revision control, undo, user administration.
> I'll not go into details but opening such an application to the public 
> would need a good amount of hard work and not to forget, security reviews.
> Stuff that the wiki already has, and (most important) somebody else is
> doing that boring maintenance work so that we can concentrate on the 
> content. 
> 
> (I know that user administration could be "borrowed" from the mediawiki
> but interfacing those applications will mean that you have to keep updating
> your code as the mediawiki code evolves.)
> 
>> I feel like the freeform nature of wikis just lends to the information
>> not being in a structured manner
> 
> True, true.
> 
>> I don't doubt that a wiki can be mangled to do something like this, 
> 
> Well. I had some doubts in the begining. :-)
> 
>> but a real database seems like such a cleaner alternative.
> 
> Cleaner, yes. But I'd rather have it dirty and full of information
> than clean, static and empty. (Oh no .. there comes the bazaar 
> and cathedral metaphor again ... :-) )
> 
> The device data is structure wise rather heterogenious. So a relational
> database might not be a very efficient way of capturing it.
> In my eyes a more valid contendor to the wiki approach would be something
> with a document oriented database like couchdb. But still you'd have
> to do write all the boring infrastructure stuff like user administration,
> history, undo...
> 
> TWiki has the ability to rather nicely blend structured data with 
> unstructured wiki articles. But I thought it more prudent to get 
> something done with the tools at hand than spend still more time 
> looking for the perfect tool ;-)
> 
>> Just a quick afterthought - bear in mind the schema I proposed is
>> something I only spent about two minutes on.  It would almost
>> certainly need some more tweaking/cleanup etc.  It meant to
>> communicate a concept, so don't get too tied up in the details of the
>> exact implementation.
> 
> 
> Jim has collected the attributes he deems important here:
> http://www.linuxtv.org/wiki/index.php/User:Jimbley#Semantics
> 
> Howeever I see some problems with the envisioned level of detail 
> regarding linux support when scaled to hundrets of devices:
> http://www.linuxtv.org/wiki/index.php/User_talk:Jimbley#Device_Database
> 
> We also had a discussion about the different users and the level of
> detail they'd need:
> http://www.linuxtv.org/wiki/index.php/User_talk:CityK#Help_with_wiki_integration
> 
> 
> Two more things:
> 
> 1.) The wiki approach allows for different "databases" to be maintained
> separately (by different people) and still have results shown in one 
> resulting table.
> 
> This could be useful for Vendor pages (listing all devices by that vendor
> independent of the boradcasting standard) or for a broadcasting
> standard page that lists all e.g. ATSC devices regardless of wether they
> have a USB or PCI interface. The only implication of splitting the 
> databases is that you need to add one line in your "querry" for each 
> database.
> 
> 
> 2.) Different devices (regardless of wether they are in the same
> "database" or in different ones) can have different sets of attributes.
> 
> If you feel that ATSC device should have separate attributes for 
> "8VSB" and "QAM" you just simply add those attributes to your
> devices and write a table template that will display those 
> attributes (and ignore things like "firmware" or "url")
> 
> The only attributes I'd like to have in all devices are "vendor",
> "device" and "did" (Device ID).
> 
> -henrik
> 
> PS: As you see from the number of links to widely different pages, 
> a wiki is NOT a good solution for discussions. Just to avoid the 
> impression that wiki's are my "new hammer". :-)
> 
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
