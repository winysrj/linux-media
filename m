Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ye0-f182.google.com ([209.85.213.182]:54373 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab3FBSPz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 14:15:55 -0400
Received: by mail-ye0-f182.google.com with SMTP id m12so238370yen.27
        for <linux-media@vger.kernel.org>; Sun, 02 Jun 2013 11:15:54 -0700 (PDT)
Date: Sun, 2 Jun 2013 14:15:44 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: [GIT PULL] git://linuxtv.org/mkrufky/dvb dib8000
Message-ID: <20130602141544.41ebdab3@vujade>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
7eac97d7e714429f7ef1ba5d35f94c07f4c34f8e:

  [media] media: pci: remove duplicate checks for EPERM (2013-05-27
  09:34:56 -0300)

are available in the git repository at:

  git://linuxtv.org/mkrufky/dvb dib8000

for you to fetch changes up to 441939932b4968cd24a1dd190629600250eea992:

  dib8000: Fix dib8000_set_frontend() never setting ret (2013-06-02
  12:53:14 -0400)

----------------------------------------------------------------
Geert Uytterhoeven (1):
      dib8000: Fix dib8000_set_frontend() never setting ret

 drivers/media/dvb-frontends/dib8000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
