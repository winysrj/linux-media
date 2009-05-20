Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f109.google.com ([209.85.222.109]:37380 "EHLO
	mail-pz0-f109.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbZETNoD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 09:44:03 -0400
Received: by pzk7 with SMTP id 7so106422pzk.33
        for <linux-media@vger.kernel.org>; Wed, 20 May 2009 06:44:04 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 20 May 2009 21:38:09 +0800
Message-ID: <3a665c760905200638x3eec97a9re1748aebcc6617d9@mail.gmail.com>
Subject: why not use memset to clear each struct content in dvb-app?
From: loody <miloody@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all:
In dvb-app, like en50221_app_mmi.c, we will call
en50221_app_mmi_create to create mmi struct.
my question is why we use below assignments
	mmi->funcs = funcs;
	mmi->closecallback = NULL;
	mmi->displaycontrolcallback = NULL;
	mmi->keypadcontrolcallback = NULL;
	mmi->subtitlesegmentcallback = NULL;
	mmi->sceneendmarkcallback = NULL;
	mmi->scenecontrolcallback = NULL;
	mmi->subtitledownloadcallback = NULL;
	mmi->flushdownloadcallback = NULL;
	mmi->enqcallback = NULL;
	mmi->menucallback = NULL;
	mmi->listcallback = NULL;
	mmi->sessions = NULL;
instead of using memset(mmi, NULL, sizeof(struct en50221_app_mmi);
thanks for your help,
miloody
