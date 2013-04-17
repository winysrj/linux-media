Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:44478 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965112Ab3DQLJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 07:09:13 -0400
Received: by mail-ve0-f180.google.com with SMTP id pb11so1288421veb.39
        for <linux-media@vger.kernel.org>; Wed, 17 Apr 2013 04:09:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOcJUbzin_70-mO44S_2b90gjOH4H64g29rO78eMxsmpshu5KQ@mail.gmail.com>
References: <516C2DC8.8080203@googlemail.com>
	<20130415135018.3a867598@redhat.com>
	<516C6AFB.1060601@googlemail.com>
	<20130415183405.44aa28eb@redhat.com>
	<CAOcJUbzin_70-mO44S_2b90gjOH4H64g29rO78eMxsmpshu5KQ@mail.gmail.com>
Date: Wed, 17 Apr 2013 07:09:12 -0400
Message-ID: <CAOcJUbyM6GVzjr2TdEcFw63Nqdny+B+8vzome1dKFusS_XgKpQ@mail.gmail.com>
Subject: Re: Patchwork and em28xx delegates
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I see this https://patchwork.linuxtv.org/patch/17834/ is delegated to
me.  If I took ownership myself then it may have been a mistake.

Either way, the patch looks good to me and makes sense, but I am not
maintaining em28xx.  Mauro, if you want to go ahead and merge his
patch then it's fine with me.  Since this was a mistake, I don't plan
to push it from my own repository.

Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>
