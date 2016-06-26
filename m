Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw2.han.skanova.net ([81.236.60.205]:44350 "EHLO
	v-smtpgw2.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbcFZPks (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2016 11:40:48 -0400
Subject: Re: media_build & cx23885
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <bb9fb742-7975-5c9a-1abc-bfd1a456d462@mbox200.swipnet.se>
 <1c7bbf34-eb2a-5f26-5058-d5c6585f698b@xs4all.nl>
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Message-ID: <af5ef8f7-685b-b21d-155d-15dc3ffa22c3@mbox200.swipnet.se>
Date: Sun, 26 Jun 2016 17:40:48 +0200
MIME-Version: 1.0
In-Reply-To: <1c7bbf34-eb2a-5f26-5058-d5c6585f698b@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-06-26 17:07, Hans Verkuil wrote:
> On 06/26/2016 04:29 PM, Torbjorn Jansson wrote:
>> Hello
>>
>> if i use media_build and modprobe cx23885 i get:
>> # modprobe cx23885
>> modprobe: ERROR: could not insert 'cx23885': Exec format error
>>
>> and on dmesg i get:
>> frame_vector: exports duplicate symbol frame_vector_create (owned by kernel)
>
> The frame_vector.ko module was incorrectly installed in /lib/modules/`uname -r`
> (probably in the kernel/mm directory). Your kernel already has that module
> compiled in, so that's the reason for the duplicate symbol.
>
> Remove that module and run 'depmod -a' and it should work again.
>
> I've seen this before, but I don't know why media_build compiles and installs it
> for a kernel that doesn't need it.
>

thanks, that helped.
i removed frame_vector.ko and that solved the problem.

is it possible that the media_build scripts always make the module but 
only installs frame_vector.ko based on some conditions?
if so, it might be my own fault.

because i test different media build versions i want an easy way to 
remove just the modules produced by media build so i tend to first build 
it normally but instead of make install i copy over the modules manually.
copying all *.ko modules under media_build/v4l to /lib/modules/`uname 
-r`/updates/media and then run depmod.

this way i can just revert by deleting the entire updates/media folder 
and wont have to go thru loads of different folders and hunt for the 
relevant .ko files.

anyway, wish i had asked you earlier back in february/march when i first 
ran into this frame_vector problem.
now i can hopefully continue my troubleshooting, i suspect i need to fix 
some application problems too since it looks like this driver (compared 
to the old from dvbsky) don't support the old dvb api for getting signal 
strength causing application issues since the program is not yet updated 
fully to new dvb api.


