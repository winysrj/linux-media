Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38411 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab3JDQEv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 12:04:51 -0400
Received: by mail-qc0-f174.google.com with SMTP id n9so2942255qcw.33
        for <linux-media@vger.kernel.org>; Fri, 04 Oct 2013 09:04:49 -0700 (PDT)
Date: Fri, 4 Oct 2013 12:04:46 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org
Subject: [GIT PULL BUG FIX] cx24117: prevent mutex to be stuck on locked
 state if FE init fails
Message-ID: <20131004120446.3b041f11@raring>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
d10e8280c4c2513d3e7350c27d8e6f0fa03a5f71:

  [media] cx24117: use hybrid_tuner_request/release_state to share
  state between multiple instances (2013-10-03 07:40:12 -0300)

are available in the git repository at:

  git://linuxtv.org/mkrufky/dvb cx24117

for you to fetch changes up to 3f9c6e0698debcdbfc1568e16eb3cc45d320cc56:

  cx24117: prevent mutex to be stuck on locked state if FE init fails
  (2013-10-04 11:13:47 -0400)

----------------------------------------------------------------
Luis Alves (1):
      cx24117: prevent mutex to be stuck on locked state if FE init
fails

 drivers/media/dvb-frontends/cx24117.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)
