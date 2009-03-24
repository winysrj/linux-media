Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:55599 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760299AbZCXRHT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 13:07:19 -0400
Date: Tue, 24 Mar 2009 12:20:08 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Thomas Kaiser <v4l@kaiser-linux.li>
cc: linux-media@vger.kernel.org
Subject: Re: gspca in the LinuxTv wiki
In-Reply-To: <49C8881F.9020104@kaiser-linux.li>
Message-ID: <alpine.LNX.2.00.0903241155070.14363@banach.math.auburn.edu>
References: <49C80321.60402@kaiser-linux.li> <alpine.LNX.2.00.0903231902140.13696@banach.math.auburn.edu> <49C8881F.9020104@kaiser-linux.li>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 24 Mar 2009, Thomas Kaiser wrote:

> Theodore Kilgore wrote:
>> But OTOH this causes a problem, too, because the manufacturers of cameras 
>> (probably some of them are not exactly manufacturers but rather packagers) 
>> are switching the electronics inside the device any time they feel like it, 
>> or if they get a large quantity of chips at a good price, or whatever. I 
>> have seen it happen several times that a certain camera keeps the make and 
>> model, but it gets a new USB Vendor:Product number. And, worst of all, it 
>> may have previously been well supported but now it is not. Someone who goes 
>> and buys the camera based upon the make and model which are stencilled on 
>> the outside of the camera and printed on the packaging material can end up 
>> being stung.
>
> Ok, just a example. See 
> http://www.kaiser-linux.li/index.php/Linux_and_Webcams#Typhoon_Easycam_USB_330K
>
> At the time I bought this cam it had a sn9c102 bridge and PAS202 and was 
> working great with gspca. Some time later, somebody reported to me that he 
> has the same cam but with a PAC7311. So I just updated my page with the new 
> information. AS of coincident, I was working on the PAC7311 at the time I got 
> this report!


So, I see. You have had to face similar problems. Fun, isn't it?

>
> Anyway, with a good and nice looking page on the LinuxTV wiki, you can get 
> more interest from some other people and they may sign up and correct the 
> page or ad new information (like this cam has now this chipset).

Yes, perhaps this will help. Somehow we all have to figure out a way to 
keep on top of these things, and the information is always shifting 
around. The idea of doing things in Wiki style, and letting people sign up 
and add information, is probably good, too.

I mention a couple of other, similar efforts to keep track of various 
devices, hoping it is possible for some wise person to come up with a way 
to avoid the problems which are associated with those efforts:

Related to the Gphoto project, we have a similar information web page, 
listing Linux compatibility for still cameras. Unfortunately, it seems 
that the web page is maintained by one individual, and he is snowed under. 
He has plenty of other work, too, of course, and he works hard. So it is 
in no way a criticism of him if I say that the page is always hopelessly 
out of date, not even managing to keep up with a complete list of the 
cameras which are already supported in libgphoto2.

There is also the list of usb devices at qbik.ch and it is (again very 
naturally) always out of date, too. It does operate more in the Wiki 
style, in that everyone can start an account there, sign up and add 
devices. However, the model they use fails, to the extent that it is not 
possible to edit what someone else has entered, and it seems not possible 
to send a mail to someone in charge, who can repair a stale entry. I am 
thinking of such a thing as an entry which says that device soandso does 
not work. Then someone (me or you, for instance) succeeds in supporting 
the device. So, we can go and add the information that now it works, in a 
comment to the existing entry. But even before anyone looks at those 
comments, beside the entry is a big red X which indicates that it does not 
work. And the person who originally filed the report is the only one who 
can change that big red X, and that person has now disappeared. If by good 
luck you are the one who created that original entry, then you and only 
you can remove that big red X. But if it was not originally your entry, 
you can't even if you know better.

So, as I said, I mention these parallel attempts at documentation with the 
hope that their problems can somehow be avoided. Perhaps it is good to try 
to do that.

Good luck,

Theodore Kilgore
