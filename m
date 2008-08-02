Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m729WcTP016351
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 05:32:38 -0400
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m729WPT7028180
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 05:32:25 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <87tze4cr3g.fsf@free.fr>
	<1217629566-26637-1-git-send-email-robert.jarzmik@free.fr>
	<1217629566-26637-2-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0808020128060.14927@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 02 Aug 2008 11:32:23 +0200
In-Reply-To: <Pine.LNX.4.64.0808020128060.14927@axis700.grange> (Guennadi
	Liakhovetski's message of "Sat\,
	2 Aug 2008 01\:31\:05 +0200 \(CEST\)")
Message-ID: <87od4b69ug.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Fix suspend/resume of pxa_camera driver
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> On Sat, 2 Aug 2008, Robert Jarzmik wrote:
>
>> PXA suspend switches off DMA core, which loses all context
>> of previously assigned descriptors. As pxa_camera driver
>> relies on DMA transfers, setup the lost descriptors on
>> resume and retrigger frame acquisition if needed.
>> 
>> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
>
> _Conditionally_ applied: I changed the subject to "Add suspend/resume 
> to...", upgraded to the current Linus' top-of-tree, and, most importantly, 
> changed this:
OK.

>> +	if ((pcdev->icd) && (pcdev->icd->ops->resume))
>> +		ret = pcdev->icd->ops->resume(pcdev->icd);
>
> To 
>
>
> Which I assume was a typo. Please, test these patches with this my change, 
> and confirm they are ok now. I'll push both of them upstream then.

To be exact: wrong copy/paste. I'm sorry not have spotted this, I have no
suspend function in mt9m111, I only used the resume one to restore the state ...

And the two lines should be :
+	if ((pcdev->icd) && (pcdev->icd->ops->suspend))
+		ret = pcdev->icd->ops->suspend(pcdev->icd, state);
                                                           ^
                                                           compile error without

Apart from that, I tested, and it's OK.

Do you have an exported git tree I can sync with ?

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
