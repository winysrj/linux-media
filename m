Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-4.cisco.com ([72.163.197.28]:53161 "EHLO
	bgl-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933859AbcA1NQ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 08:16:58 -0500
Subject: Re: [PATCH v1 1/1] tea575x: convert to library
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
References: <1450470720-89768-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1453984596.2521.293.camel@linux.intel.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <56AA1265.6030109@cisco.com>
Date: Thu, 28 Jan 2016 14:06:45 +0100
MIME-Version: 1.0
In-Reply-To: <1453984596.2521.293.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/28/2016 01:36 PM, Andy Shevchenko wrote:
> On Fri, 2015-12-18 at 22:32 +0200, Andy Shevchenko wrote:
>> The module is used only as a library for now. Remove module init and
>> exit
>> routines to show this.
>>
>> While here, remove FSF snail address and attach EXPORT_SYMBOL()
>> macros to
>> corresponding functions.
>
> Any comment on this?

Not yet. It's in my todo pile so I will get to it. It's low prio, so 
this might take some time.

Regards,

	Hans

>
> The patch has been compiled and tested with SF64-PCR radio tuner (fm801
> based).
>
>>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> ---
>>   drivers/media/radio/tea575x.c | 21 ++-------------------
>>   1 file changed, 2 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/media/radio/tea575x.c
>> b/drivers/media/radio/tea575x.c
>> index 43d1ea5..21cd5de 100644
>> --- a/drivers/media/radio/tea575x.c
>> +++ b/drivers/media/radio/tea575x.c
>> @@ -14,10 +14,6 @@
>>    *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>    *   GNU General Public License for more details.
>>    *
>> - *   You should have received a copy of the GNU General Public
>> License
>> - *   along with this program; if not, write to the Free Software
>> - *   Foundation, Inc., 59 Temple Place, Suite 330, Boston,
>> MA  02111-1307 USA
>> - *
>>    */
>>
>>   #include <linux/delay.h>
>> @@ -226,6 +222,7 @@ void snd_tea575x_set_freq(struct snd_tea575x
>> *tea)
>>   	snd_tea575x_write(tea, tea->val);
>>   	tea->freq = snd_tea575x_val_to_freq(tea, tea->val);
>>   }
>> +EXPORT_SYMBOL(snd_tea575x_set_freq);
>>
>>   /*
>>    * Linux Video interface
>> @@ -582,25 +579,11 @@ int snd_tea575x_init(struct snd_tea575x *tea,
>> struct module *owner)
>>
>>   	return 0;
>>   }
>> +EXPORT_SYMBOL(snd_tea575x_init);
>>
>>   void snd_tea575x_exit(struct snd_tea575x *tea)
>>   {
>>   	video_unregister_device(&tea->vd);
>>   	v4l2_ctrl_handler_free(tea->vd.ctrl_handler);
>>   }
>> -
>> -static int __init alsa_tea575x_module_init(void)
>> -{
>> -	return 0;
>> -}
>> -
>> -static void __exit alsa_tea575x_module_exit(void)
>> -{
>> -}
>> -
>> -module_init(alsa_tea575x_module_init)
>> -module_exit(alsa_tea575x_module_exit)
>> -
>> -EXPORT_SYMBOL(snd_tea575x_init);
>>   EXPORT_SYMBOL(snd_tea575x_exit);
>> -EXPORT_SYMBOL(snd_tea575x_set_freq);
>

