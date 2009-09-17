Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33408 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbZIQKwf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 06:52:35 -0400
Date: Thu, 17 Sep 2009 07:51:59 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [hg:v4l-dvb] DocBook/media: Add isdb-t documentation
Message-ID: <20090917075159.48d64fcf@pedra.chehab.org>
In-Reply-To: <alpine.LRH.1.10.0909170858330.6193@pub3.ifh.de>
References: <20090917020923.5572340f@pedra.chehab.org>
	<alpine.LRH.1.10.0909170858330.6193@pub3.ifh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Sep 2009 09:06:44 +0200 (CEST)
Patrick Boettcher <pboettcher@kernellabs.com> escreveu:

> Hi Mauro,
> 
> On Thu, 17 Sep 2009, Mauro Carvalho Chehab wrote:
> 
> > Hi Patrick,
> >
> > I've added the isdb-t docs at the new media DocBook. Please double check. It were
> > generated from your text document at dvb-spec dir.
> 
> Thanks a lot for doing this job :) . You didn't remove the txt-file. Any 
> future change I will do in the DocBook, so no need anymore for the 
> txt-file.

Ok. I'll do a patch removing the txt.

> > Starting from now, I kindly ask developers that need to touch at Media API to
> > always send an update to the DocBook. It would be great if someone could write
> > a complete S2API spec.
> 
> Hmm... as ISDB-T is based on S2API-mechanisms, it should not be that 
> hard...
> 
> Should we do a list of S2API-ids described per standard? Like that e.g. 
> frequency would appear everytime, but as it has a different meaning/scale 
> for different standards, it seems logic to split it up in standards.

Good point.

Maybe we can have an initial section with the common parameters, adding <xref>
to each standard for details.

Another possibility would be to have a table with all S2API-id's x all
standards, saying yes/no if that tag applies. If yes, <xref> or <callout> pointing to each standard meaning. Like:

|PARAMETER    | DVB-S2 |ISDB-T |	...
+-------------+--------+--------+ ...
FREQ		YES(1)	YES(2)	...
LAYER_A		NO	YES(3)	...
...



Cheers,
Mauro
