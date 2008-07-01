Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m610AvCi005599
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 20:10:57 -0400
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m610Aj6q017654
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 20:10:45 -0400
Message-ID: <486975F0.7040102@linuxtv.org>
Date: Mon, 30 Jun 2008 20:10:24 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Paul Kelly <pksings@gmail.com>
References: <1214835761.24479.4.camel@phred.pksings.com>
In-Reply-To: <1214835761.24479.4.camel@phred.pksings.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: DVICO dual express second tuner?
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

Paul Kelly wrote:
> Hello all;
> 
> I got the latest tree and firmware and successfully brought up a new
> DVICO dual express and can tune HD cable.
> 
> According to the marketing fluff this card has two tuners and can tune
> either two digital HD streams or one analog and one HD stream. 
> 
> Can anyone give me any idea how to make it do that? Mythtv only
> identifies tuner 0. 
> 
> Any information needed will happily be supplied, please ask.
> 
> Thanks in advance

Paul,

There is a bug in the cx23885 driver that prevents us from using both Transport buses at the same time.

stoth is working to fix that bug now -- after the bug is fixed, we'll enable the second transport bus.

I'd expect it to be all fixed within a week or two.

Regards,

Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
