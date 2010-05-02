Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55636 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab0EBMg5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 May 2010 08:36:57 -0400
Received: by bwz19 with SMTP id 19so851879bwz.21
        for <linux-media@vger.kernel.org>; Sun, 02 May 2010 05:36:56 -0700 (PDT)
Message-ID: <4BDD71E6.7050405@googlemail.com>
Date: Sun, 02 May 2010 14:36:54 +0200
From: Michal Chlosta <michal.chlosta@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [vdr] externalplayer and xineliboutput plugin
References: <4BD70CFA.1010404@gmail.com>
In-Reply-To: <4BD70CFA.1010404@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Nobody an idea ? - Can somebody explain to me what a player with
> PlayMode pmNone should do ?
> This is the problem:
>
> Apr 22 23:41:05 vdr vdr: [3204]
> ERROR: /dev/dvb/adapter1/dvr0: Device or resource busy
>
> If some application is started with external player
> streamdev/vnsi-plugin with frontend xineliboutput produces below error
> .. xine not
>
> Thanks !
>
> Steffen
>
> Steffen Barszus wrote:
> >/  Hi !
> />/
> />/  I currently try to track down a problem of externalplayer and
> />/  xineliboutput.
> />/
> />/  The problem is, that if used with xineliboutput plugin and PlayMode
> />/  pmNone, one device is not available. With xine this does not happen.
> />/  May assumption is that here:
> />/
> />/  device.c:
> />/      641   m_PlayMode = PlayMode;
> />/      642
> />/      643   TrickSpeed(-1);
> />/      644   if (m_PlayMode == pmAudioOnlyBlack) {
> />/      645     TRACE("pmAudioOnlyBlack -->  BlankDisplay, NoVideo");
> />/      646     ForEach(m_clients,&cXinelibThread::BlankDisplay);
> />/      647     ForEach(m_clients,&cXinelibThread::SetNoVideo, true);
> />/      648   } else {
> />/      649     if(m_liveMode)
> />/      650       ForEach(m_clients,&cXinelibThread::SetNoVideo,
> />/    m_RadioStream); 651     else
> />/      652       ForEach(m_clients,&cXinelibThread::SetNoVideo,
> />/      653               m_RadioStream&&  (m_AudioCount<1));
> />/      654     Clear();
> />/      655   }
> />/
> />/  An action is missing to take care of pmNone, i.e. to stop trying to
> />/  receive and decode something.
> />/
> />/  This is the Problem:
> />/  Apr 22 23:41:05 vdr vdr: [3204] receiver on device 2 thread started
> />/  (pid=2952, tid=3204)
> />/  Apr 22 23:41:05 vdr vdr: [3204]
> />/  ERROR: /dev/dvb/adapter1/dvr0: Device or resource busy
> />/  Apr 22 23:41:05
> />/  vdr vdr: [3204] receiver on device 2 thread ended (pid=2952, 
> tid=3204)
> />/
> />/  This does not happen if i use xine, or if i shut down vdr-sxfe 
> before i
> />/  try to use streamdev oder VNSI plugin.
> />/
> />/
> />/  My understanding is that the frontend device needs to do the 
> required
> />/  action and let vdr know afterwards in order to free the device.
> />/
> />/  Would appreciate if someone with more understanding of the internals
> />/  could add his opinion here ...
> />/
> />/  Kind Regards
> />/
> />/  Steffen
> />/
> />/  _______________________________________________
> />/  vdr mailing list
> />/  vdr at linuxtv.org 
> <http://www.linuxtv.org/cgi-bin/mailman/listinfo/vdr>
> />/ http://www.linuxtv.org/cgi-bin/mailman/listinfo/vdr
> />/
> />/
> /


Hi!

Got the same problem here.
No problem with xine.

xineliboutput 1.0.6+cvs20100331.2000
externalplayer 0.1.0-19

best rgds
   Micha
