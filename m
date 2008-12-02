Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB25dmX4000407
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 00:39:48 -0500
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB25dU4N007526
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 00:39:30 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>
Date: Tue, 2 Dec 2008 11:09:12 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403E904F156@dbde02.ent.ti.com>
In-Reply-To: <200811281154.06274.david-b@pacbell.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"davinci-linux-open-source-bounces@linux.davincidsp.com"
	<davinci-linux-open-source-bounces@linux.davincidsp.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH 2/2] TVP514x Driver with Review comments fixed
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

Hi David,

Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: David Brownell [mailto:david-b@pacbell.net]
> Sent: Saturday, November 29, 2008 1:24 AM
> To: Hiremath, Vaibhav
> Cc: video4linux-list@redhat.com; davinci-linux-open-source-
> bounces@linux.davincidsp.com; linux-omap@vger.kernel.org; Jadav,
> Brijesh R; Shah, Hardik; Hadli, Manjunath; R, Sivaraj; Karicheri,
> Muralidharan
> Subject: Re: [PATCH 2/2] TVP514x Driver with Review comments fixed
> 
> On Friday 28 November 2008, David Brownell wrote:
> > On Friday 28 November 2008, Hiremath, Vaibhav wrote:
> > > Will have to now think how to differentiate between these
> > > two chips and handle this sequence.
> >
> > That's really easy, the "id" parameter to probe() tells you:
> >
> > 	if (strcmp(id->name, "tvp5146") == 0)
> > 		/* original '46 part ... */;
> > 	else if (strmcp(id->name, "tvp5146m2") == 0)
> > 		/* new '46m2 version ... */
> > 	... etc
> 
> ... although it's even easier to use id->driver_data to
> hold, for example, a bitmask telling various attributes
> of that particular device.  Examples here:
> 
> 	- does it have the extra '46 registers?
> 	- does it use the original '46 init sequence?
> 	- or the new m2 one?
> 	- or the original '47 init sequence?
> 	- or the new m1 version?
> 	- ...
> 
> Another common use of driver_data is to hold a pointer
> to a struct holding chip-specific data that doesn't fit
> into a simple bitmask.
> 
[Hiremath, Vaibhav] I am trying to use/save complete init sequence in 
id->driver_data -

static const struct i2c_device_id tvp514x_id[] = {
	{"tvp5146", (unsigned int)&tvp5146_init},
	{"tvp5146m2", (unsigned int)&tvp514xm_init},
	{"tvp5147", (unsigned int)&tvp5147_init},
	{"tvp5147m1", (unsigned int)&tvp514xm_init},
	{},
};

NOTE: Please note that init sequence for 46, 47 are different.

But I came to know that, client structure doesn't have any parameter which will provide me the index under this id table. The only differentiating parameter we have is "name" (decoder->client->driver->name).

I can use "id->driver_data" only in my probe function without any index. 

So left with only following options -

1) 
 	if (strcmp(id->name, "tvp5146") == 0)
 		/* original 46 init seq */;
	else if (strcmp(id->name, "tvp5147") == 0) 
		/* original 47 init seq */
 	else if ((strmcp(id->name, "tvp5146m2") == 0) || 
			(strmcp(id->name, "tvp5147m1") == 0))
		/* New 46/47 init seq */

2)

Driver specific structure must contain either of
	- Index of i2c_device_id table, use this to get the driver_data. (This also requires string compare to get the index.)
	- Pointer to init_reg_seq, which is pointer to array of structure for tvp514x_regs. This is little bit ugly, since will have to export tvp514x_regs structure.
	- Or have pointer to i2c_device_id itself. (Implemented and tested)


I prefer to use second option, instead of comparing the name string in s_power every time. And it will be very easy to add even more chips providing generic solution; we need to just add entry to i2c_device_id with expected init sequence and you are done.

Any suggestions or inputs appreciated???

> - Dave


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
