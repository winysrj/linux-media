Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9JF2pFd005471
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 11:02:51 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9JF1sUn002650
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 11:01:54 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1087833fga.7
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 08:01:54 -0700 (PDT)
Message-ID: <30353c3d0810190801y6dce8824gc4348323c7550ea9@mail.gmail.com>
Date: Sun, 19 Oct 2008 11:01:54 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Greg KH" <gregkh@suse.de>
In-Reply-To: <20081018034100.GA12142@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0810171920y154a8bc4w584751acac95ac7b@mail.gmail.com>
	<alpine.LFD.2.00.0810180014300.13825@areia.chehab.org>
	<20081018034100.GA12142@suse.de>
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: ibmcam oops
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

On Fri, Oct 17, 2008 at 11:41 PM, Greg KH <gregkh@suse.de> wrote:
> On Sat, Oct 18, 2008 at 12:31:02AM -0300, Mauro Carvalho Chehab wrote:
>> On Fri, 17 Oct 2008, David Ellingsworth wrote:
>>
>>> I'm not sure if it matters or not, but the ibmcam driver in the
>>> Mauro's linux-2.6 git tree in the for_linus branch is currently
>>> broken. I haven't ever gotten this driver to work with my camera and
>>> am thus not interested in fixing it. The crash occurred immediately
>>> after plugging in the camera. Below is the resulting dmesg info.
>>
>> The kernel OOPS seem to be caused by -git commit
>> a482f327ff56bc3cf53176a7eb736cea47291a1d, from Greg.
>>
>> It is using uvd->dev->dev, but is equal to NULL during most of the _probe
>> code.
>>
>> Could you please try the enclosed patch? It is against -hg tree, but will
>> likely apply fine also at -git.
>
> Ick, sorry about that, your patch looks fine.
>
> thanks,
>
> greg k-h
>

Yes, this patch seems to fix the oops.

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
