Return-path: <linux-media-owner@vger.kernel.org>
Received: from proxy1.bredband.net ([195.54.101.71]:33429 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934659AbZGQODR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2009 10:03:17 -0400
Received: from iph1.telenor.se (195.54.127.132) by proxy1.bredband.net (7.3.140.3)
        id 49F5A15201A84C0D for linux-media@vger.kernel.org; Fri, 17 Jul 2009 16:03:14 +0200
Message-ID: <2f15391f4f76f6a3126c0e8a9d61562c.squirrel@mail.kurelid.se>
Date: Fri, 17 Jul 2009 16:03:12 +0200
Subject: Re: [PATCH] firedtv: refine AVC debugging
From: "Henrik Kurelid" <henke@kurelid.se>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: "Henrik Kurelid" <henke@kurelid.se>, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I gave this some thought when I implemented it. These are "should not happend"-situations where the drivers or hardware sends unknown/unimplemented
commands. Rather than making sure that they are never seen in the logs I wanted them to always be logged (as long as some debug logging is turned
on) since they indicate driver/hw problems.

Do you disagree with my reasoning? I guess that the best would be to make sure that all unknown messages are always logged as warnings with their
full content.

Regarding your other comment, I will fix that in the next patch version.

Regards,
Henrik



> Henrik Kurelid wrote:
>> +static int debug_fcp_opcode_flag_set(unsigned int opcode,
>> +                                    const u8 *data, int length) +{
>> +       switch (opcode) {
>> +       case AVC_OPCODE_VENDOR:                 break;
>> +       case AVC_OPCODE_READ_DESCRIPTOR:        return avc_debug & AVC_DEBUG_READ_DESCRIPTOR; +       case AVC_OPCODE_DSIT:                  
return avc_debug & AVC_DEBUG_DSIT; +       case AVC_OPCODE_DSD:                    return avc_debug & AVC_DEBUG_DSD; +       default:            
                   return 1;
>> +       }
>> +
>> +       if (length < 7 ||
>> +           data[3] != SFE_VENDOR_DE_COMPANYID_0 ||
>> +           data[4] != SFE_VENDOR_DE_COMPANYID_1 ||
>> +           data[5] != SFE_VENDOR_DE_COMPANYID_2)
>> +               return 1;
>> +
>> +       switch (data[6]) {
>> +       case SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL: return avc_debug & AVC_DEBUG_REGISTER_REMOTE_CONTROL; +       case
SFE_VENDOR_OPCODE_LNB_CONTROL:             return avc_debug & AVC_DEBUG_LNB_CONTROL; +       case SFE_VENDOR_OPCODE_TUNE_QPSK:              
return avc_debug & AVC_DEBUG_TUNE_QPSK; +       case SFE_VENDOR_OPCODE_TUNE_QPSK2:              return avc_debug & AVC_DEBUG_TUNE_QPSK2; +      
case SFE_VENDOR_OPCODE_HOST2CA:                 return avc_debug & AVC_DEBUG_HOST2CA; +       case SFE_VENDOR_OPCODE_CA2HOST:                
return avc_debug & AVC_DEBUG_CA2HOST; +       }
>> +       return 1;
>> +}
>> +
>>  static void debug_fcp(const u8 *data, int length)
>>  {
>>         unsigned int subunit_type, subunit_id, op;
>>         const char *prefix = data[0] > 7 ? "FCP <- " : "FCP -> ";
>> -       if (avc_debug & AVC_DEBUG_FCP_SUBACTIONS) {
>> -               subunit_type = data[1] >> 3;
>> -               subunit_id = data[1] & 7;
>> -               op = subunit_type == 0x1e || subunit_id == 5 ? ~0 : data[2]; +       subunit_type = data[1] >> 3;
>> +       subunit_id = data[1] & 7;
>> +       op = subunit_type == 0x1e || subunit_id == 5 ? ~0 : data[2]; +       if (debug_fcp_opcode_flag_set(op, data, length)) {
>>                 printk(KERN_INFO "%ssu=%x.%x l=%d: %-8s - %s\n",
> [...]
>
> Shouldn't the three return statements in debug_fcp_opcode_flag_set be 'return 0' rather than one?
> --
> Stefan Richter
> -=====-==--= -=== =---=
> http://arcgraph.de/sr/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



