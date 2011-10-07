Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758292Ab1JGB7L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Oct 2011 21:59:11 -0400
Message-ID: <4E8E5CE9.8030604@redhat.com>
Date: Thu, 06 Oct 2011 22:59:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org, Mikael Magnusson <mikachu@gmail.com>
Subject: tvtime at linuxtv.org
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com> <CAGoCfiy2hnH0Xoz_+Q8JgcB-tzuTGbfv8QdK0kv+ttP7t+EZKg@mail.gmail.com> <CAGoCfixa0pr048=-P3OUkZ2HMaY471eNO79BON0vjSVa1eRcTw@mail.gmail.com> <4E66E532.4050402@redhat.com> <CAGoCfiw7vjprc_skYYAXy9sTA7zkYEWtzXy9tEmJD+q8aazPog@mail.gmail.com> <CAGoCfiw-QnfVVwOhejwbMmb+K2F0VDwN_L-6E37w+=jKYGGFkg@mail.gmail.com> <CAGoCfixTqXaDU++-k_tn1NMkg4xXNcL=qvezggqe6BqEH+h5xg@mail.gmail.com>
In-Reply-To: <CAGoCfixTqXaDU++-k_tn1NMkg4xXNcL=qvezggqe6BqEH+h5xg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

I had some discussions with Mikael today at the #linuxtv channel about
tvtime. Mikael has write access to the tvtime site at sourceforge and he
is doing some maintainance on it for some time, and worked on some bugs
from Gentoo, and also imported some stuff from Ubuntu.

I've merged his patches on my repository:
	http://git.linuxtv.org/mchehab/tvtime.git

Tvtime is compiling, at least on Fedora 15. I also added your patch there,
and changed the latency delay to 50ms. I didn't test it yet. I'll do it later
today or tomorrow.

Btw, Mikael updated the Related Sites there to point to the LinuxTV site:
	http://tvtime.sourceforge.net/links.html

He will try to contact Vektor again, in order to get his ack about adding
a note at the main page pointing to us.

I think we should move those patches to the main repository after testing the
merges, and give write rights to the ones that are interested on maintaining
tvtime.

I'm interested on it, and also Mikael.

IMHO, after testing it and applying a few other patches that Mikael might have,
it is time for us to rename the version to 1.10 and do a tvtime release.

Would that work for you?

Thank you!
Mauro
