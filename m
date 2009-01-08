Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n081puqp001182
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 20:51:56 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n081pPRE007672
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 20:51:25 -0500
Date: Wed, 7 Jan 2009 23:50:58 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
Message-ID: <20090107235058.15bf6fa9@pedra.chehab.org>
In-Reply-To: <412bdbff0901071024p7a16343cha01c09ea6ae2b5a2@mail.gmail.com>
References: <c785bba30812301646vf7572dcua9361eb10ec58716@mail.gmail.com>
	<412bdbff0812311420n3f42e13ew899be73cd855ba5d@mail.gmail.com>
	<c785bba30812311424r87bd070v9a01828c77d6a2a6@mail.gmail.com>
	<412bdbff0812311435n429787ecmbcab8de00ba05b6b@mail.gmail.com>
	<c785bba30812311444l65b3825aq844b79dd6f420c09@mail.gmail.com>
	<412bdbff0812311452o64538cdav4b948f6a9214ccdd@mail.gmail.com>
	<c785bba30901020850y51c7b9d2i47fd418828cd150c@mail.gmail.com>
	<c785bba30901030922y17d67d0bm822304a650a0e812@mail.gmail.com>
	<c785bba30901051633g7808197fl6d377420d799120c@mail.gmail.com>
	<c785bba30901070927x9be4bdcr84ceb792ccac7afb@mail.gmail.com>
	<412bdbff0901071024p7a16343cha01c09ea6ae2b5a2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list <video4linux-list@redhat.com>
Subject: Re: em28xx issues
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

On Wed, 7 Jan 2009 13:24:10 -0500
"Devin Heitmueller" <devin.heitmueller@gmail.com> wrote:

> A quick look at the code does show something interesting:
> 
> There are a number of cases where we dereference the result of the
> "INPUT" macro as follows without checking the number of inputs
> defined:
> 
> route.input = INPUT(index)->vmux;
> 
> and here is the macro definition:
> 
> #define INPUT(nr) (&em28xx_boards[dev->model].input[nr])
> 
> It may be the case that a NULL pointer deference would occur if there
> was only one input defined (as is the case for the PointNix camera).
> 
> As a test, you might want to copy the other two inputs for the
> PointNix device profile from some other device, and see if you still
> hits an oops during input selection.

I've reviewed the input stuff at em28xx driver, to avoid accessing input
entries that aren't defined (so, filled with zeros).

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
