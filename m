Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:50049 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976AbZIQHG5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 03:06:57 -0400
Date: Thu, 17 Sep 2009 09:06:44 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Fw: [hg:v4l-dvb] DocBook/media: Add isdb-t documentation
In-Reply-To: <20090917020923.5572340f@pedra.chehab.org>
Message-ID: <alpine.LRH.1.10.0909170858330.6193@pub3.ifh.de>
References: <20090917020923.5572340f@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thu, 17 Sep 2009, Mauro Carvalho Chehab wrote:

> Hi Patrick,
>
> I've added the isdb-t docs at the new media DocBook. Please double check. It were
> generated from your text document at dvb-spec dir.

Thanks a lot for doing this job :) . You didn't remove the txt-file. Any 
future change I will do in the DocBook, so no need anymore for the 
txt-file.

> Starting from now, I kindly ask developers that need to touch at Media API to
> always send an update to the DocBook. It would be great if someone could write
> a complete S2API spec.

Hmm... as ISDB-T is based on S2API-mechanisms, it should not be that 
hard...

Should we do a list of S2API-ids described per standard? Like that e.g. 
frequency would appear everytime, but as it has a different meaning/scale 
for different standards, it seems logic to split it up in standards.

--

Patrick
http://www.kernellabs.com/
