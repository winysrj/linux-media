Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55206
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751782AbdGHUkV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Jul 2017 16:40:21 -0400
Date: Sat, 8 Jul 2017 17:40:10 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Kaffeine with VLC backend.
Message-ID: <20170708174010.6af2eed0@vento.lan>
In-Reply-To: <d62db204-ff77-fe8e-d9dc-95ba49fae6dd@gmail.com>
References: <6a28b31a-1b67-f113-9456-19b910674a6a@gmail.com>
        <a94b59bd-0cdc-2856-a022-7190a7b3f6d5@gmail.com>
        <20170708160947.299e1402@vento.lan>
        <d62db204-ff77-fe8e-d9dc-95ba49fae6dd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 8 Jul 2017 21:30:32 +0100
Malcolm Priestley <tvboxspy@gmail.com> escreveu:

> On 08/07/17 20:09, Mauro Carvalho Chehab wrote:
> > Em Sat, 8 Jul 2017 18:13:14 +0100
> > Malcolm Priestley <tvboxspy@gmail.com> escreveu:
> >   
> >> On 08/07/17 08:17, Malcolm Priestley wrote:  
> >>> Hi Mauro
> >>>
> >>> Have you encountered a strange bug with Kaffeine with VLC backend.
> >>>
> >>> Certain channels will not play correctly, the recordings will also not
> >>> play in VLC.
> >>>
> >>> However, they will play fine with xine player. Only some channels are
> >>> affected of those provided by SKY such as 12207 V on Astra 28.2.
> >>>
> >>> These channels will play fine with Kaffeine with xine backend they also
> >>> play with VLC's dvb-s interface.
> >>>
> >>> Any ideas what could be wrong with the TS format?
> >>>
> >>> I am wondering if SKY are inserting something into the format.  
> >>
> >> Just a follow up it appears that the PCR is missing from the stream
> >> which is transmitted on a different PID.
> >>
> >> In the case of the above channel manually adding PID 8190 the backend
> >> plays normally.  
> > 
> > You're likely using an old version of Kaffeine. See this BZ:  
> I was already using the latest git tree.

Ah, ok.

> 
> > 	
> > 	https://bugs.kde.org/show_bug.cgi?id=376805
> > No it hasn't fixed it the PCR is still missing from the stream.  
> 
> Somehow, PCR PID needs to be added to the PID filter.
> 
> Unless there is a way VLC can ignore it like xine does?

I suspect that it is probably easier to patch Kaffeine for it to filter
the PCR PIDs and send to libVLC.

Part of the filtering logic is at:
	src/dvb/dvbsi.cpp

Please notice, however, that part of the contents of this file is
auto-generated via tools/updatedvbsi.cpp from tools/dvbsi.xml.

Thanks,
Mauro
