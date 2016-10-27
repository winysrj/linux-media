Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49647
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934036AbcJ0RQP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 13:16:15 -0400
Date: Thu, 27 Oct 2016 15:16:09 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: DocBook documentation on linuxtv.org
Message-ID: <20161027151609.01ce955e@vento.lan>
In-Reply-To: <20161027112745.GV9460@valkosipuli.retiisi.org.uk>
References: <20161027112745.GV9460@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 27 Oct 2016 14:27:45 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> The link labelled "v4l-dvb-apis/" on the
> <URL:https://www.linuxtv.org/downloads/> page still points to the old
> DocBook documentation. Could you update it, and perhaps even remove the old
> DocBook documentation so people do not accidentally continue to use it?


Thanks for noticing it! 

Yeah, I forgot to update the link there.

I replaced it to v4l-dvb-apis-new/ link. I'm keeping the old DocBook
documentation on the same place for reference, but it is only
visible via the https://linuxtv.org/docs.php, if one clicks at the
"OLD Linux Media Infrastructure API" link.

I opted to keep the last version on DocBook there for a while, as we
could find some discrepancies due to its conversion (I found already
a few broken cross-references in the past). So, it could still be
useful as a reference, if we find something odd at the new docs.

Regards,
Mauro





Thanks,
Mauro
