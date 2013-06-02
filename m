Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f181.google.com ([209.85.161.181]:62173 "EHLO
	mail-gg0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab3FBSSD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 14:18:03 -0400
Received: by mail-gg0-f181.google.com with SMTP id 21so876217ggh.12
        for <linux-media@vger.kernel.org>; Sun, 02 Jun 2013 11:18:02 -0700 (PDT)
Date: Sun, 2 Jun 2013 14:17:59 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: [GIT PULL] git://linuxtv.org/mkrufky/tuners r820t
Message-ID: <20130602141759.0007bed7@vujade>
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

  git://linuxtv.org/mkrufky/tuners r820t

for you to fetch changes up to 0fe5886ef7a961fc184ffd7f125027a99716faa1:

  r820t: avoid potential memcpy buffer overflow in shadow_store()
  (2013-06-02 13:31:19 -0400)

----------------------------------------------------------------
Gianluca Gennari (3):
      r820t: do not double-free fe->tuner_priv in r820t_release()
      r820t: remove redundant initializations in r820t_attach()
      r820t: avoid potential memcpy buffer overflow in shadow_store()

 drivers/media/tuners/r820t.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)
