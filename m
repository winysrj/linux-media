Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2C9K25f019193
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 05:20:02 -0400
Received: from as3.cineca.com (as3.cineca.com [130.186.84.211])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2C9JRlc005198
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 05:19:28 -0400
Message-ID: <47D7A00C.1020307@cineca.it>
From: Andrea Venturi <a.venturi@cineca.it>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
References: <20080312082530.GA3570@lmwangpc.yuvad.cn>
In-Reply-To: <20080312082530.GA3570@lmwangpc.yuvad.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Mar 2008 10:19:08 +0100 (MET)
Subject: Re: any recommendations for SD/SDI cards under linux?
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

Limin Wang wrote:
> Hi,
> 
> I am a newbie to the list and can't find how to search on the archive, so
> had to ask the question here.
> If you have any recommendations for SDI cards under linux, would you mind
> telling me? 

hi,

we are using Dektec card as ASI ports (for DVB transport stream), under
linux, and they do have quite a good linux driver, fully open source and
more than GPL (public domain?) albeit not linux-dvb compliant, but it's
just a character device.

the SDI link is the same physical stuff of ASI so for example this card
shoud work for your task too:

  http://www.dektec.com/Products/DTA-145/index.asp

YMMV, i don't have a direct experience about SDI usage, but i had a good
experience with Dektec stuff so i suggest them quite wholeheartedly
(btw, don't have any economic interest.. :-)

bye

andrea venturi

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
