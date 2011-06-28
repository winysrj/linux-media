Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:8176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757741Ab1F1Mnb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 08:43:31 -0400
Message-ID: <4E09CC6A.8080900@redhat.com>
Date: Tue, 28 Jun 2011 09:43:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFCv3 PATCH 12/18] vb2_poll: don't start DMA, leave that to
 the first read().
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl> <f1a14e0985ddaa053e45522fe7bbdfae56057ec2.1307458245.git.hans.verkuil@cisco.com> <4E08FBA5.5080006@redhat.com> <201106280933.57364.hverkuil@xs4all.nl> <4E09B919.9040100@redhat.com> <cd2c9732-aee5-492b-ade2-bee084f79739@email.android.com>
In-Reply-To: <cd2c9732-aee5-492b-ade2-bee084f79739@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 28-06-2011 09:21, Andy Walls escreveu:
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

>> I'm not very comfortable with vb2 returning unexpected errors there.
>> Also,
>> for me it is clear that, if read will fail, POLLERR should be rised.
>>
>> Mauro. 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> It is also the case that a driver's poll method should never sleep.

True.

> I will try to find the conversation I had with laurent on interpreting the POSIX spec on error returns from select() and poll().  I will also try to find links to previos discussion with Hans on this.
> 
> One issue is how to start streaming with apps that:
> - Open /dev/video/ in a nonblocking mode, and
> - Use the read() method
> 
> while doing it in a way that is POSIX compliant and doesn't break existing apps.  

Well, a first call for poll() may rise a thread that will prepare the buffers, and
return with 0 while there's no data available.

> The other constraint is to ensure when only poll()-ing for exception conditions, not having significant IO side effects.
> 
> I'm pretty sure sleeping in a driver's poll() method, or having significant side effects, is not ine the spirit of the POSIX select() and poll(), even if the letter of POSIX says nothing about it.
> 
> The method I suggested to Hans is completely POSIX compliant for apps using read() and select() and was checked against MythTV as having no bad side effects.  (And by thought experiment doesn't break any sensible app using nonblocking IO with select() and read().)
> 
> I did not do analysis for apps that use mmap(), which I guess is the current concern.

The concern is that it is pointing that there are available data, even when there is an error.
This looks like a POSIX violation for me.

Cheers,
Mauro.
