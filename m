Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:45652 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751774AbbD3Oja (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:39:30 -0400
Message-ID: <55423E97.7000609@xs4all.nl>
Date: Thu, 30 Apr 2015 16:39:19 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 03/14] saa7134: fix indent issues
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>	<1e8158b3d1f9472fc0ec2776876a907575c5548c.1430235781.git.mchehab@osg.samsung.com>	<5541C9C1.1000800@xs4all.nl> <20150430110829.34b9f9f9@recife.lan>
In-Reply-To: <20150430110829.34b9f9f9@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/30/2015 04:08 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 30 Apr 2015 08:20:49 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 04/28/2015 05:43 PM, Mauro Carvalho Chehab wrote:
>>> As reported by smatch:
>>> 	drivers/media/pci/saa7134/saa7134-cards.c:7197 saa7134_xc2028_callback() warn: inconsistent indenting
>>> 	drivers/media/pci/saa7134/saa7134-cards.c:7846 saa7134_board_init2() warn: inconsistent indenting
>>> 	drivers/media/pci/saa7134/saa7134-cards.c:7913 saa7134_board_init2() warn: inconsistent indenting
>>>
>>> While here, fix a few CodingStyle issues on the affected code
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>
>>> diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
>>> index 3ca078057755..d48fd5338db5 100644
>>> --- a/drivers/media/pci/saa7134/saa7134-cards.c
>>> +++ b/drivers/media/pci/saa7134/saa7134-cards.c
>>> @@ -7194,7 +7194,7 @@ static int saa7134_xc2028_callback(struct saa7134_dev *dev,
>>>  			saa7134_set_gpio(dev, 20, 1);
>>>  		break;
>>>  		}
>>> -	return 0;
>>> +		return 0;
>>>  	}
>>>  	return -EINVAL;
>>>  }
>>> @@ -7842,7 +7842,8 @@ int saa7134_board_init2(struct saa7134_dev *dev)
>>>  				break;
>>>  			case 0x001d:
>>>  				dev->tuner_type = TUNER_PHILIPS_FMD1216ME_MK3;
>>> -					printk(KERN_INFO "%s Board has DVB-T\n", dev->name);
>>> +				printk(KERN_INFO "%s Board has DVB-T\n",
>>> +				       dev->name);
>>
>> If you're changing this anyway, why not use pr_info instead?
> 
> Converting it to pr_foo is actually complex. Anyway, I found some time
> today to do such conversion. I'll be adding on a patch series I'm about
> to send.

I was just referring to this single patch, not the whole driver! :-)

Anyway, for the saa7134 patches:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
>>
>>>  				break;
>>>  			default:
>>>  				printk(KERN_ERR "%s Can't determine tuner type %x from EEPROM\n", dev->name, tuner_t);
>>> @@ -7903,13 +7904,15 @@ int saa7134_board_init2(struct saa7134_dev *dev)
>>>  	case SAA7134_BOARD_ASUSTeK_TVFM7135:
>>>  	/* The card below is detected as card=53, but is different */
>>>  	       if (dev->autodetected && (dev->eedata[0x27] == 0x03)) {
>>> -		       dev->board = SAA7134_BOARD_ASUSTeK_P7131_ANALOG;
>>> -		       printk(KERN_INFO "%s: P7131 analog only, using "
>>> -						       "entry of %s\n",
>>> -		       dev->name, saa7134_boards[dev->board].name);
>>> +			dev->board = SAA7134_BOARD_ASUSTeK_P7131_ANALOG;
>>> +			printk(KERN_INFO
>>> +			       "%s: P7131 analog only, using entry of %s\n",
>>
>> Ditto.
>>
>>> +			dev->name, saa7134_boards[dev->board].name);
>>>  
>>> -			/* IR init has already happened for other cards, so
>>> -			 * we have to catch up. */
>>> +			/*
>>> +			 * IR init has already happened for other cards, so
>>> +			 * we have to catch up.
>>> +			 */
>>>  			dev->has_remote = SAA7134_REMOTE_GPIO;
>>>  			saa7134_input_init1(dev);
>>>  	       }
>>>
>>
>> Regards,
>>
>> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

