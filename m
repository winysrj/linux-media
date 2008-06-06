Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m56CMZJO014571
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 08:22:35 -0400
Received: from linos.es (centrodatos.linos.es [86.109.105.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m56CMNBa008362
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 08:22:24 -0400
Message-ID: <48492BE9.1050201@linos.es>
Date: Fri, 06 Jun 2008 14:22:01 +0200
From: Linos <info@linos.es>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <484920B9.4010107@linos.es> <20080606121719.GA506@daniel.bse>
In-Reply-To: <20080606121719.GA506@daniel.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: bttv driver problem last kernels
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
> On Fri, Jun 06, 2008 at 01:34:17PM +0200, Linos wrote:
>> Hello all,
>> 	i am using a bttv multicapture board and i have been having 
>> 	increasing problems in last kernels, i am using two programs to capture my 
>> video input for security reasons (helix producer and mp4live from mpeg4ip 
>> project) since the first versions of v4l2 in 2.4 patched kernel versions i 
>> can attach the two programs at the same time at the same video input, only 
>> loss framerate
> 
> You are relying on undocumented behaviour when two v4l1 applications are
> reading from bttv at the same time. Furthermore the v4l2 standards says
> 
> "1.1.4. Shared Data Streams
> 
> V4L2 drivers should not support multiple applications reading or writing
> the same data stream on a device by copying buffers, time multiplexing
> or similar means. This is better handled by a proxy application in user
> space. When the driver supports stream sharing anyway it must be
> implemented transparently. The V4L2 API does not specify how conflicts
> are solved."
> 
> You should change your setup to use only one application accessing the
> device.
> 
>   Daniel
> 

I have two options here:

1) maintain 2.6.20 kernel version
2) search for an application proxy that lets me use the same input for two programs

i have a windows client connecting the two streams in different options, i cant disable any of them and i cant 
double the number of capture inputs in the system, anyway i have not read the v4l2 standard so you have reason 
that i should not be doing that but i have been doing from 2.4.17 (with patches) to 2.6.20.

Regards,
Miguel Angel.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
