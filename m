Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37487 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbbJXLqX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2015 07:46:23 -0400
Received: by wicfv8 with SMTP id fv8so61491149wic.0
        for <linux-media@vger.kernel.org>; Sat, 24 Oct 2015 04:46:22 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 24 Oct 2015 12:46:22 +0100
Message-ID: <CAOQWjw339WO4Paiy6bdam4fMjnzbTC1DvBR_tuimrUtebg5+gA@mail.gmail.com>
Subject: dtv-scan-tables: please remove dvb-s/Eurobird1-28.5E
From: Nick Morrott <knowledgejunkie@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As noted in my previous patch for Astra-28.2E, the Eurobird 1
satellite was removed from the 28E cluster a few months ago and
repositioned at 33E. My Astra patch removes the relevant Eurobird
entries from the Astra-28.2E scan table.

However, the separate dvb-s/Eurobird1-28.5E scan table should be
removed from the repository and recreated with the correct
name/contents in due course.

Thanks,
Nick
