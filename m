Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9KIhbhP007770
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 14:43:37 -0400
Received: from linos.es (centrodatos.linos.es [86.109.105.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9KIge8X002379
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 14:42:40 -0400
Message-ID: <48FCD11F.1020604@linos.es>
Date: Mon, 20 Oct 2008 20:42:39 +0200
From: Linos <info@linos.es>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <48FC8DF1.8010807@linos.es> <20081020161436.GB1298@daniel.bse>
	<48FCB94C.90505@linos.es>
	<30353c3d0810201023j3464c9b5udc58b0c0966ad0f2@mail.gmail.com>
	<20081020182536.GA1750@daniel.bse>
In-Reply-To: <20081020182536.GA1750@daniel.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: bttv 2.6.26 problem
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

Daniel Glöckner escribió:
> On Mon, Oct 20, 2008 at 01:23:25PM -0400, David Ellingsworth wrote:
>> On Mon, Oct 20, 2008 at 1:01 PM, Linos <info@linos.es> wrote:
>>> Daniel Glöckner escribió:
>>>>  vmm.height=352;
>>>>  vmm.width=288;
> 
> D'oh!
> I swapped width and height..
> 
>> I believe the changes Daniel suggested would have to be applied to the
>> source of helix producer in order to work.
> 
> I didn't test helix producer, but with my simple test app and correct
> width and height it works.
> 
>> None the less, the proper
>> fix would be to fix the associated bug in the driver which is the real
>> cause of the problem.
> 
> Agreed
> 
>   Daniel
> 

Yes now works, thanks Daniel, i should have try to read the source anyway, the
name can not be clearer hehehe.

Regards,
Miguel Angel.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
