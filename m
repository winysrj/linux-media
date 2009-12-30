Return-path: <linux-media-owner@vger.kernel.org>
Received: from luna.schedom-europe.net ([193.109.184.86]:44074 "EHLO
	luna.schedom-europe.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbZL3VWS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2009 16:22:18 -0500
Message-ID: <4B3BC2F2.30806@dommel.be>
Date: Wed, 30 Dec 2009 22:15:30 +0100
From: Johan <johan.vanderkolk@dommel.be>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: av7110 error reporting
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I need some guidance on error messages..

The machine receives these messages in the systemlog (dmesg)

[ 7673.168026] dvb-ttpci: StartHWFilter error  buf 0b07 0010 07e9 b96a  
ret 0  handle ffff
[ 7674.192025] dvb-ttpci: StartHWFilter error  buf 0b07 0010 07ee b96a  
ret 0  handle ffff
[ 7675.224025] dvb-ttpci: StartHWFilter error  buf 0b07 0010 07f3 b96a  
ret 0  handle ffff
[ 7676.248128] dvb-ttpci: StartHWFilter error  buf 0b07 0010 07f9 b96a  
ret 0  handle ffff
[ 7677.280026] dvb-ttpci: StartHWFilter error  buf 0b07 0010 07fd b96a  
ret 0  handle ffff
[ 7678.312025] dvb-ttpci: StartHWFilter error  buf 0b07 0010 0803 b96a  
ret 0  handle ffff

These start as soon as I view or record a channel, and obviously fills 
up the log quickly.

I believe the code that generates these messages is at the bottom of 
this message (part of av7110.c). This code was introduced in 2005 to 
improve error reporting.

Currently I run today's v4l-dvb (using a hg update), and kernel 
2.6.31-16. (Ubuntu), however the issue occurred in older combinations as 
well (over a year ago), so it is not introduced by the last kernels or 
DVB driverset.

The message seems to be triggered by the variable "handle" being larger 
then 32. On my system it always reports ffff.

Am I looking at faulty hardware, or can I resolve this issue more 
elegant than just disabling the fault report?
(keep in mind that I do not have a programming/coding background)



Johan



start of code--->
static int StartHWFilter(struct dvb_demux_filter *dvbdmxfilter)
{
    struct dvb_demux_feed *dvbdmxfeed = dvbdmxfilter->feed;
    struct av7110 *av7110 = dvbdmxfeed->demux->priv;
    u16 buf[20];
    int ret, i;
    u16 handle;
//    u16 mode = 0x0320;
    u16 mode = 0xb96a;

    dprintk(4, "%p\n", av7110);

    if (av7110->full_ts)
        return 0;

    if (dvbdmxfilter->type == DMX_TYPE_SEC) {
        if (hw_sections) {
            buf[4] = (dvbdmxfilter->filter.filter_value[0] << 8) |
                dvbdmxfilter->maskandmode[0];
            for (i = 3; i < 18; i++)
                buf[i + 4 - 2] =
                    (dvbdmxfilter->filter.filter_value[i] << 8) |
                    dvbdmxfilter->maskandmode[i];
            mode = 4;
        }
    } else if ((dvbdmxfeed->ts_type & TS_PACKET) &&
           !(dvbdmxfeed->ts_type & TS_PAYLOAD_ONLY)) {
        av7110_p2t_init(&av7110->p2t_filter[dvbdmxfilter->index], 
dvbdmxfeed);
    }

    buf[0] = (COMTYPE_PID_FILTER << 8) + AddPIDFilter;
    buf[1] = 16;
    buf[2] = dvbdmxfeed->pid;
    buf[3] = mode;

    ret = av7110_fw_request(av7110, buf, 20, &handle, 1);
    if (ret != 0 || handle >= 32) {
        printk("dvb-ttpci: %s error  buf %04x %04x %04x %04x  "
                "ret %d  handle %04x\n",
                __func__, buf[0], buf[1], buf[2], buf[3],
                ret, handle);
        dvbdmxfilter->hw_handle = 0xffff;
        if (!ret)
            ret = -1;
        return ret;
    }

    av7110->handle2filter[handle] = dvbdmxfilter;
    dvbdmxfilter->hw_handle = handle;

    return ret;
}

<------end of code
