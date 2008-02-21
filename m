Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1LC0hpW007781
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 07:00:43 -0500
Received: from smtp0.lie-comtel.li (smtp0.lie-comtel.li [217.173.238.80])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1LC0A4W017272
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 07:00:10 -0500
Message-ID: <47BD67C8.5000305@kaiser-linux.li>
Date: Thu, 21 Feb 2008 13:00:08 +0100
From: Thomas Kaiser <linux-dvb@kaiser-linux.li>
MIME-Version: 1.0
To: "H. Willstrand" <h.willstrand@gmail.com>
References: <47BC8BFC.2000602@kaiser-linux.li>	
	<47BC90CA.1000707@kaiser-linux.li>	
	<175f5a0f0802201254q7dc96190k35caafe9ba7d3274@mail.gmail.com>	
	<47BC9788.7070604@kaiser-linux.li>
	<20080220215850.GA2391@daniel.bse>	
	<47BCA5BA.20009@kaiser-linux.li>	
	<175f5a0f0802201441n5ea7bb58rdfa70663799edcad@mail.gmail.com>	
	<47BCB5DB.8000800@kaiser-linux.li>	
	<175f5a0f0802201602i52187c1fxb2e980c7e86fcca6@mail.gmail.com>	
	<20080221012048.GA2924@daniel.bse>
	<175f5a0f0802210110k11dc73f6pbbdd7100c1ca8fdb@mail.gmail.com>
In-Reply-To: <175f5a0f0802210110k11dc73f6pbbdd7100c1ca8fdb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: V4L2_PIX_FMT_RAW
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

H. Willstrand wrote:
> On Thu, Feb 21, 2008 at 2:20 AM, Daniel Glöckner <daniel-gl@gmx.net> wrote:
>> On Thu, Feb 21, 2008 at 01:02:39AM +0100, H. Willstrand wrote:
>>  > What's the problem with having a name of the formalized data in the
>>  > video stream? ie raw do not mean undefined.
>>
>>  I thought you wanted to avoid having to define V4L2_PIX_FMT_x for an
>>  exploding number of proprietary formats that are quite similar but still
>>  incompatible. It makes sense for formats that are used by more than one
>>  driver.
> 
> Correct, the number of unique pixel formats should be kept down.
> Again, comparing with digital cameras there are >200 proprietary
> formats and there is a "clean-up" on-going where the "market" is
> aiming for a OpenRAW.
> 
> However, by declaring a generic RAW format (which is then driver
> specific) doesn't help the user mode app developers. Calling a
> multitude of libraries to see if you get lucky might not be a good
> idea.
> 
> Still, I'm suspectious about the definition "raw" used here.
> RAW should mean unprocessed image data:
> * no white balance adjustment
> * no color saturation adjustments
> * no contrast adjustments
> * no sharpness improvements
> * no compression with loss

Yes, raw means "as it is" no stripping, decoding  or removing of SOF headers are 
done in the driver. May be V4L2_PIX_FMT_AII (AII -> As It Is) is the better name?

> 
> So, by looking for similarities in the "raw" formats where available
> there should be a potential to consolidate them.
> 
>>
>>  > I don't see how separate RAW ioctl's will add value to the V4l2 API,
>>  > it fits into the current API.
>>
>>  Yes, it does. Each driver having multiple raw formats just needs a
>>  private control id to select one.
>>
> I was more thinking about the VIDIOC_S_RAW stuff, a VIDIOC_S_FMT
> should do the job.
> I.e. I think there should be strong reasons to break V4L2 API behavior.
> 
> Harri


-- 
http://www.kaiser-linux.li

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
