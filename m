Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:39901 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaGWTJp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 15:09:45 -0400
MIME-Version: 1.0
In-Reply-To: <53D00578.3090906@hauke-m.de>
References: <53CA9A77.6060409@hauke-m.de> <CAB=NE6WvY1ZnwogYR0YLuiMUOeRvqeEjhhnLHUpeJjteSTwfGA@mail.gmail.com>
 <20140723145724.3102ae3a.m.chehab@samsung.com> <CAB=NE6W3+fRQkxe-TEKVyPSMXWNVr44TNhCwd6g-7nH+83jx=Q@mail.gmail.com>
 <53D00578.3090906@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 23 Jul 2014 12:09:24 -0700
Message-ID: <CAB=NE6V+T1H1Eoem_C7RoKU_LYYbd7fXL47QbfJ=E_Ur5J7=SA@mail.gmail.com>
Subject: Re: Removal of regulator framework
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"backports@vger.kernel.org" <backports@vger.kernel.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 23, 2014 at 11:56 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> carrying some regularity drivers which are needed for some specific
> media driver does not look like a big problem. The current problem from
> my side is that we carry all regularity drivers by default and that
> causes some problems. Many of these driver are used only on one specific
> SoC product line and uses their often changing interface, so they break
> often.
>
> When all the regulator drivers are only needed for the media driver I
> would add just add the driver which are actually used by a shipped media
> driver and nothing more.

Makes sense. I'm suggesting we can trim even more by only keeping
media drivers we really should care for and its dependencies. We need
a white list then, do we want to start off with perhaps the list I
posted? Media folks, is there anything else we should carry that would
help the media folks?

  Luis
