Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55063
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753068AbdGHTJz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Jul 2017 15:09:55 -0400
Date: Sat, 8 Jul 2017 16:09:47 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Kaffeine with VLC backend.
Message-ID: <20170708160947.299e1402@vento.lan>
In-Reply-To: <a94b59bd-0cdc-2856-a022-7190a7b3f6d5@gmail.com>
References: <6a28b31a-1b67-f113-9456-19b910674a6a@gmail.com>
        <a94b59bd-0cdc-2856-a022-7190a7b3f6d5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 8 Jul 2017 18:13:14 +0100
Malcolm Priestley <tvboxspy@gmail.com> escreveu:

> On 08/07/17 08:17, Malcolm Priestley wrote:
> > Hi Mauro
> > 
> > Have you encountered a strange bug with Kaffeine with VLC backend.
> > 
> > Certain channels will not play correctly, the recordings will also not 
> > play in VLC.
> > 
> > However, they will play fine with xine player. Only some channels are 
> > affected of those provided by SKY such as 12207 V on Astra 28.2.
> > 
> > These channels will play fine with Kaffeine with xine backend they also 
> > play with VLC's dvb-s interface.
> > 
> > Any ideas what could be wrong with the TS format?
> > 
> > I am wondering if SKY are inserting something into the format.  
> 
> Just a follow up it appears that the PCR is missing from the stream 
> which is transmitted on a different PID.
> 
> In the case of the above channel manually adding PID 8190 the backend 
> plays normally.

You're likely using an old version of Kaffeine. See this BZ:
	
	https://bugs.kde.org/show_bug.cgi?id=376805


Thanks,
Mauro
