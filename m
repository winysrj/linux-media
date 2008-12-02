Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB26TFfx018145
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 01:29:15 -0500
Received: from ag-out-0708.google.com (ag-out-0708.google.com [72.14.246.241])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB26SVZt025564
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 01:28:31 -0500
Received: by ag-out-0708.google.com with SMTP id 23so2093266agd.7
	for <video4linux-list@redhat.com>; Mon, 01 Dec 2008 22:28:31 -0800 (PST)
Message-ID: <5d5443650812012228u5aad36a2jc3e9e68cd61c27e3@mail.gmail.com>
Date: Tue, 2 Dec 2008 11:58:31 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <20081201202209.5cea1f4b@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812011451.06156.hverkuil@xs4all.nl>
	<5d5443650812011014q55a96540gc8a4b97be951f2fd@mail.gmail.com>
	<20081201202209.5cea1f4b@pedra.chehab.org>
Cc: v4l <video4linux-list@redhat.com>, Sakari Ailus <sakari.ailus@nokia.com>,
	linux-kernel@vger.kernel.org,
	v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Mauro,

>
> This is one of the lack of the features on mercurial. It doesn't have a meta
> tag for committer. On mercurial, the -hg user and the author should be the same
> person.
>
> Since we want to identify the patch origin (e.g. whose v4l/dvb maintainer got
> the patch), we use the internal "user" meta-tag as the committer, and an extra
> tag, at the patch description for the author (From:).
>
> When creating the -git patch, the "From:" tag is replaced, by script, for
> "Author:", I add my SOB there, and, I add myself as the -git committer (on git
> we have both meta-tags).

Isn't it good time to move v4l2-dvb tree to GIT? I am not aware of any
hg-to-git repo. converter, but I can check with hg and git community.
It could be difficult at first, but I am very confident that there are
many GIT users here than mercurial, and yes your v4l-dvb maintenance
process might change due move from GIT, but atleast you will not have
to internal user meta-data per patch.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
