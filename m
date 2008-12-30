Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBU1LT5k001275
	for <video4linux-list@redhat.com>; Mon, 29 Dec 2008 20:21:29 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.234])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBU1LD81009754
	for <video4linux-list@redhat.com>; Mon, 29 Dec 2008 20:21:13 -0500
Received: by rv-out-0506.google.com with SMTP id f6so5207012rvb.51
	for <video4linux-list@redhat.com>; Mon, 29 Dec 2008 17:21:12 -0800 (PST)
Message-ID: <26aa882f0812291721o2e3c1798oe9ace7faabbf2f0c@mail.gmail.com>
Date: Mon, 29 Dec 2008 20:21:12 -0500
From: "Jackson Yee" <jackson@gotpossum.com>
To: "Gregg Germain" <saville@comcast.net>
In-Reply-To: <4959707D.4010509@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4959707D.4010509@comcast.net>
Cc: video4linux-list@redhat.com
Subject: Re: xawtv and 64 bit LINUX systems...
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

Xawtv should work fine on 64 bit systems. I've got a gentoo-amd64
system doing fine with an ImpactVCB card.

If you're running Fedora, you probably already have Xawtv available through Yum:

http://www.fedorafaq.org/#installsoftware

Otherwise, one of the packages from Dag should probably work:

http://dag.wieers.com/rpm/packages/xawtv/

Regards,
Jackson Yee
The Possum Company
540-818-4079
me@gotpossum.com

On Mon, Dec 29, 2008 at 7:51 PM, Gregg Germain <saville@comcast.net> wrote:
> Hi all,
>
>  I'm a newbie to xawtv and I'd like to install it on my Fedora Core 10, 64
> bit system.
>
> Is xawtv-3.95.tar.gz  the package that I should use? will it work with 64
> bit systems?
>
> thanks
>
> Gregg

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
